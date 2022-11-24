abstract class Failure implements Exception {
  // This message is going to appear to the user as a toast.
  final String errorText;

  final StackTrace? stackTrace;

  Failure({required this.errorText, required this.stackTrace});

  @override
  String toString() => 'ERROR MESSAGE: $errorText\n\nSTACK TRACE: ${stackTrace.toString()}';
}

class DefaultException extends Failure {
  DefaultException({String? errorText, required StackTrace stackTrace})
      : super(errorText: errorText ?? 'Algo deu errado, entre em contato com suporte.', stackTrace: stackTrace);
}

class ConnectionException extends Failure {
  ConnectionException({required StackTrace stackTrace})
      : super(errorText: 'Sem conexão com a internet, verifique.', stackTrace: stackTrace);
}

class ServerException extends Failure {
  ServerException({required StackTrace stackTrace})
      : super(errorText: 'Erro na resposta do servidor', stackTrace: stackTrace);
}

class TimeoutException extends Failure {
  TimeoutException({required StackTrace stackTrace})
      : super(errorText: 'Erro ao conectar ao servidor', stackTrace: stackTrace);
}

class NotFoundException extends Failure {
  NotFoundException({required StackTrace stackTrace})
      : super(errorText: 'Nenhum dado foi encontrado', stackTrace: stackTrace);
}
