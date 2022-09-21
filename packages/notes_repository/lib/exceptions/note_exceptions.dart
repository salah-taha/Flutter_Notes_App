class GetAllNotesException implements Exception {
  final String message;
  final Exception exception;

  GetAllNotesException(this.message, this.exception);
}

class GetNoteByIdException implements Exception {
  final String message;
  final Exception exception;

  GetNoteByIdException(this.message, this.exception);
}

class InsertNoteException implements Exception {
  final String message;
  final Exception exception;

  InsertNoteException(this.message, this.exception);
}

class UpdateNoteException implements Exception {
  final String message;
  final Exception exception;

  UpdateNoteException(this.message, this.exception);
}

class ClearNotesException implements Exception {
  final String message;
  final Exception exception;

  ClearNotesException(this.message, this.exception);
}
