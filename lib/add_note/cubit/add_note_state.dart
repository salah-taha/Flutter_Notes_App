part of 'add_note_cubit.dart';

class AddNoteState extends Equatable {
  const AddNoteState({
    this.note = '',
    this.userId,
    this.noteId,
    this.status = FormStatus.initial,
    this.error,
  });

  final String note;
  final String? noteId;
  final String? userId;

  final FormStatus status;
  final String? error;

  AddNoteState copyWith({
    String? note,
    String? userId,
    FormStatus? status,
    String? error,
    String? noteId,
  }) {
    return AddNoteState(
      note: note ?? this.note,
      userId: userId ?? this.userId,
      noteId: noteId ?? this.noteId,
      status: status ?? FormStatus.initial,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        note,
        userId,
        status,
        error,
      ];
}
