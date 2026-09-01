import '../../../models/asaas_connection_model.dart';

enum AsaasConnectionStep { form, confirmation }

class AsaasConnectionState {
  final AsaasConnectionStep step;
  final String apiKey;
  final bool makeRequest;
  final AsaasConnectionModel? connection;

  const AsaasConnectionState({
    required this.step,
    required this.apiKey,
    required this.makeRequest,
    required this.connection,
  });

  factory AsaasConnectionState.initial() {
    return const AsaasConnectionState(
      step: AsaasConnectionStep.form,
      apiKey: '',
      makeRequest: false,
      connection: null,
    );
  }

  AsaasConnectionState copyWith({
    AsaasConnectionStep? step,
    String? apiKey,
    bool? makeRequest,
    AsaasConnectionModel? connection,
    bool clearConnection = false,
  }) {
    return AsaasConnectionState(
      step: step ?? this.step,
      apiKey: apiKey ?? this.apiKey,
      makeRequest: makeRequest ?? this.makeRequest,
      connection: clearConnection ? null : connection ?? this.connection,
    );
  }
}
