import '../../../models/asaas_connection_model.dart';

enum AsaasConnectionStep { form, confirmation }

class AsaasConnectionState {
  final AsaasConnectionStep step;
  final String connectionName;
  final String apiKey;
  final bool makeRequest;
  final AsaasConnectionModel? connection;

  const AsaasConnectionState({
    required this.step,
    required this.connectionName,
    required this.apiKey,
    required this.makeRequest,
    required this.connection,
  });

  factory AsaasConnectionState.initial() {
    return const AsaasConnectionState(
      step: AsaasConnectionStep.form,
      connectionName: '',
      apiKey: '',
      makeRequest: false,
      connection: null,
    );
  }

  AsaasConnectionState copyWith({
    AsaasConnectionStep? step,
    String? connectionName,
    String? apiKey,
    bool? makeRequest,
    AsaasConnectionModel? connection,
    bool clearConnection = false,
  }) {
    return AsaasConnectionState(
      step: step ?? this.step,
      connectionName: connectionName ?? this.connectionName,
      apiKey: apiKey ?? this.apiKey,
      makeRequest: makeRequest ?? this.makeRequest,
      connection: clearConnection ? null : connection ?? this.connection,
    );
  }
}
