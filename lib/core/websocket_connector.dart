import 'package:flutter/material.dart';
import 'package:gloria_finance/core/websocket_service.dart';
import 'package:provider/provider.dart';

import '../features/auth/pages/login/store/auth_session_store.dart';

class WebSocketConnector extends StatefulWidget {
  final Widget child;

  const WebSocketConnector({super.key, required this.child});

  @override
  State<WebSocketConnector> createState() => _WebSocketConnectorState();
}

class _WebSocketConnectorState extends State<WebSocketConnector> {
  bool _isWebSocketConnected = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _handleConnectionChange();
  }

  void _handleConnectionChange() {
    final authStore = Provider.of<AuthSessionStore>(context);

    final currentClientId = authStore.state.session.memberId;
    final isLoggedIn = authStore.isLoggedIn();

    // Condiciones para conectar:
    // 1. Usuario logueado
    // 2. ClientId válido
    // 3. WebSocket no está ya conectado
    bool shouldConnect =
        isLoggedIn && currentClientId!.isNotEmpty && !_isWebSocketConnected;

    if (shouldConnect) {
      WebSocketService().connect(currentClientId);
      _isWebSocketConnected = true;
    }
    // Si el usuario se deslogueó o no hay wallets
    else if (!isLoggedIn && _isWebSocketConnected) {
      print('🔌 Desconectando WebSocket (login: $isLoggedIn)');
      WebSocketService().disconnect();
      _isWebSocketConnected = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
