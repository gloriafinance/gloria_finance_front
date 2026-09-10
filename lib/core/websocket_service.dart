import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

/// Eventos que el servidor puede enviar al cliente
enum RealTimeEventNotifications {
  paidPix('PaidPix');

  const RealTimeEventNotifications(this.value);

  final String value;
}

/// Servicio singleton para gestionar conexiones WebSocket con el servidor
class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();

  factory WebSocketService() {
    return _instance;
  }

  io.Socket? _socket;
  bool _isConnected = false;
  String? _memberId;
  void Function(dynamic data)? _onPaidPix;

  WebSocketService._internal();

  void connect(String memberId) {
    print('🚀 INICIO connect() con clientId: $memberId');

    if (_isConnected && _memberId == memberId) {
      print('WebSocket ya está conectado para el cliente: $memberId');
      return;
    }

    disconnect();
    _memberId = memberId;

    final String serverUrl = _getServerUrl();

    try {
      _socket = io.io(
        serverUrl,
        io.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .setTimeout(5000)
            .setQuery({'clientId': memberId})
            .build(),
      );

      print('✅ Socket creado exitosamente');
      _setupEventListeners();
      print('✅ Event listeners configurados');
    } catch (e) {
      print('❌ ERROR creando socket: $e');
    }
  }

  String _getServerUrl() {
    final apiProd = 'https://api.gloriafinance.com.br';

    final apiDev = 'https://api.gloriafinance.com.br';
    //final apiDev = 'http://0.0.0.0:5200/api/';

    if (kReleaseMode) {
      return apiProd;
    }

    return apiDev;
  }

  void _setupEventListeners() {
    if (_socket == null) {
      print('❌ ERROR: _socket es null en _setupEventListeners');
      return;
    }

    print('🔧 Configurando listeners del socket...');

    _socket!.onConnect((_) {
      _isConnected = true;
      print('✅ CONECTADO! WebSocket conectado exitosamente');
    });

    _socket!.onDisconnect((reason) {
      _isConnected = false;
      print('❌ DESCONECTADO! Razón: $reason');
    });

    _socket!.onConnectError((error) {
      _isConnected = false;
      print('🚨 ERROR DE CONEXION! $error');
    });

    _socket!.onError((error) {
      print('⚠️ ERROR GENERAL! $error');
    });

    _socket!.on(RealTimeEventNotifications.paidPix.value, (data) {
      _onPaidPix?.call(data);
    });
  }

  void onPaidPix(void Function(dynamic data) callback) {
    _onPaidPix = callback;
  }

  void offPaidPix(void Function(dynamic data) callback) {
    if (identical(_onPaidPix, callback)) {
      _onPaidPix = null;
    }
  }

  void disconnect() {
    if (_socket != null) {
      print('Desconectando WebSocket...');
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
    }
    _isConnected = false;
    _memberId = null;
  }

  bool get isConnected => _isConnected;

  String? get clientId => _memberId;

  void reconnect() {
    final memberId = _memberId;
    if (memberId != null) {
      connect(memberId);
    }
  }
}
