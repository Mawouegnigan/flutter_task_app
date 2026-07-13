class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException() : super('Erreur de connexion au serveur');
}

class UnauthorizedException extends AppException {
  const UnauthorizedException() : super('Session expirée, veuillez vous reconnecter');
}

class NotFoundException extends AppException {
  const NotFoundException() : super('Ressource introuvable');
}

class ServerException extends AppException {
  const ServerException() : super('Erreur serveur, veuillez réessayer');
}