// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:notes_repository/notes_repository.dart';

part 'notes_list_event.dart';
part 'notes_list_state.dart';

class Filter {
  final User? user;
  final String? text;

  const Filter({
    this.user,
    this.text,
  });

  String get getText {
    if (text == null && user == null) {
      return '';
    }
    return '(Filter by: ${user?.username ?? ''} ${text ?? ''})';
  }

  Filter copyWith({
    required User? user,
    required String? text,
  }) {
    return Filter(
      user: user,
      text: text,
    );
  }
}

class NotesListBloc extends Bloc<NotesListEvent, NotesListState> {
  NotesListBloc(this._dataSource) : super(const NotesListState()) {
    on<LoadNotes>(_onLoadNotes);
    on<FilterByTitle>(_onFilterByTitle);
    on<FilterByUser>(_onFilterByUser);
    on<RemoveFilterByUser>(_onRemoveFilterByUser);
    on<RemoveFilterByTitle>(_onRemoveFilterByTitle);
    on<ClearAllNotes>(_onClearAllNotes);
  }

  final NotesRepository _dataSource;

  void _onLoadNotes(
    LoadNotes event,
    Emitter<NotesListState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final notes = await _dataSource.getAllNotes();
      emit(state.copyWith(allNotes: notes, isLoading: false));
    } catch (e) {
      emit(
        state.copyWith(
          error: "Couldn't load notes",
          isLoading: false,
        ),
      );
    }
  }

  void _onFilterByTitle(
    FilterByTitle event,
    Emitter<NotesListState> emit,
  ) {
    emit(state.copyWith(
        filter:
            state.filter.copyWith(text: event.title, user: state.filter.user)));
  }

  void _onFilterByUser(
    FilterByUser event,
    Emitter<NotesListState> emit,
  ) {
    emit(state.copyWith(
        filter:
            state.filter.copyWith(user: event.user, text: state.filter.text)));
  }

  void _onRemoveFilterByUser(
    RemoveFilterByUser event,
    Emitter<NotesListState> emit,
  ) {
    emit(state.copyWith(
        filter: state.filter.copyWith(user: null, text: state.filter.text)));
  }

  void _onRemoveFilterByTitle(
    RemoveFilterByTitle event,
    Emitter<NotesListState> emit,
  ) {
    emit(state.copyWith(
        filter: state.filter.copyWith(text: null, user: state.filter.user)));
  }

  void _onClearAllNotes(
    ClearAllNotes event,
    Emitter<NotesListState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _dataSource.clearNotes();
      final notes = await _dataSource.getAllNotes();
      emit(state.copyWith(allNotes: notes, isLoading: false));
    } catch (e) {
      emit(
        state.copyWith(
          error: "Error Hppened whild clearing notes",
          isLoading: false,
        ),
      );
    }
  }
}
