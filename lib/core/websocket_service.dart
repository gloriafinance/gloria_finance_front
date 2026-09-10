import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

/// Eventos que el servidor puede enviar al cliente
enum RealTimeEventNotifications {
  paidPix('PAID_PIX');

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

  // Callbacks para eventos
  // Function(Wallet)? _onBalanceUpdate;
  // Function(Transaction)? _onNewTransaction;

  WebSocketService._internal();

  void connect(String memberId) {
    print('🚀 INICIO connect() con clientId: $memberId');

    if (_isConnected && _memberId == memberId) {
      print('WebSocket ya está conectado para el cliente: $memberId');
      return;
    }

    _memberId = memberId;
    disconnect(); // Desconectar conexión previa si existe

    final String serverUrl = _getServerUrl();

    try {
      _socket = io.io(
        serverUrl,
        io.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .setTimeout(5000)
            .setQuery({'memberId': memberId})
            .build(),
      );

      print('✅ Socket creado exitosamente');
      _setupEventListeners();
      print('✅ Event listeners configurados');
    } catch (e) {
      print('❌ ERROR creando socket: $e');
    }
  }

  /// Obtiene la URL del servidor según el entorno
  String _getServerUrl() {
    final apiProd = 'https://api.gloriafinance.com.br';
    //final apiDev = 'https://api.gloriafinance.com.br';
    final apiDev = 'http://0.0.0.0:5200';

    if (kReleaseMode) {
      return apiProd;
    }

    return apiDev;
  }

  /// Configura los listeners de eventos del socket
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

    // Listener para actualizaciones de balance de wallet
    // _socket!.on(RealTimeEventNotifications.balanceWallet.value, (data) {
    //   print('📡 BALANCE_WALLET RECIBIDO! Datos: $data');
    //   try {
    //     final update = Wallet.fromJson(data);
    //
    //     if (_onBalanceUpdate != null) {
    //       _onBalanceUpdate!(update);
    //     }
    //   } catch (e) {
    //     print('❌ Error procesando actualización: $e');
    //   }
    // });
  }

  /// Registra callback para actualizaciones de balance
  // void onBalanceUpdate(Function(Wallet) callback) {
  //   print('🔗 Registrando callback para actualizaciones de balance');
  //   _onBalanceUpdate = callback;
  //   print('✅ Callback registrado exitosamente');
  // }

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
    if (_memberId != null) {
      connect(_memberId!);
    }
  }
}
