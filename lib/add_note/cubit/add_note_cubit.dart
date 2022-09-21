// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:notes_repository/exceptions/exceptions.dart';
import 'package:notes_repository/notes_repository.dart';

part 'add_note_state.dart';

enum FormStatus { loading, initial, submitting, success, failure }

class AddNoteCubit extends Cubit<AddNoteState> {
  AddNoteCubit(this._dataSource) : super(const AddNoteState());

  final NotesRepository _dataSource;

  void loadNote(String noteId) async {
    try {
      emit(state.copyWith(status: FormStatus.loading, noteId: noteId));
      final note = await _dataSource.getNoteById(noteId);
      emit(
        state.copyWith(
          note: note.text,
          userId: note.userId,
          status: FormStatus.initial,
        ),
      );
    } on GetNoteByIdException catch (e) {
      emit(state.copyWith(status: FormStatus.failure, error: e.message));
    }
  }

  void noteChanged(String note) {
    emit(state.copyWith(note: note));
  }

  void assignedUserCnaged(String userId) {
    emit(state.copyWith(userId: userId));
  }

  void saveNote() async {
    try {
      emit(state.copyWith(status: FormStatus.submitting));
      if (state.noteId != null) {
        await _dataSource.updateNote(Note(
          id: state.noteId!,
          text: state.note,
          userId: state.userId,
          placeDateTime: DateTime.now(),
        ));
      } else {
        await _dataSource.insertNote(Note(
          id: '',
          text: state.note,
          userId: state.userId,
          placeDateTime: DateTime.now(),
        ));
      }
      emit(state.copyWith(status: FormStatus.success));
    } on UpdateNoteException catch (e) {
      emit(state.copyWith(status: FormStatus.failure, error: e.message));
    }
  }
}
