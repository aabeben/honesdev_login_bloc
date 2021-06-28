class AuthenticationException implements Exception {
  final String message;

  const AuthenticationException({this.message = 'Unknown error happened!'});
}
