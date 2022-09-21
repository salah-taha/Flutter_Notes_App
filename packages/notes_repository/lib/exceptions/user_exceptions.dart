class GetAllUsersException implements Exception {
  final String message;
  final Exception exception;

  GetAllUsersException(this.message, this.exception);
}

class InsertUserException implements Exception {
  final String message;
  final Exception exception;

  InsertUserException(this.message, this.exception);
}

class DeleteUserException implements Exception {
  final String message;
  final Exception exception;

  DeleteUserException(this.message, this.exception);
}
