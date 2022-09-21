class GetAllInterestsException implements Exception {
  final String message;
  final Exception exception;

  GetAllInterestsException(this.message, this.exception);
}
