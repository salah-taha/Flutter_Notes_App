part of 'notes_list_bloc.dart';

class NotesListState extends Equatable {
  const NotesListState({
    this.allNotes = const [],
    this.filter = const Filter(),
    this.isLoading = true,
    this.error,
  });

  final List<Note> allNotes;
  final bool isLoading;
  final String? error;
  final Filter filter;

  List<Note> get notes => allNotes.where((note) {
        if (filter.user != null && note.userId != filter.user!.id) {
          return false;
        }
        if (filter.text != null &&
            note.text
                    ?.toLowerCase()
                    .contains(filter.text!.trim().toLowerCase()) ==
                false) {
          return false;
        }
        return true;
      }).toList();

  // copyWith
  NotesListState copyWith({
    List<Note>? allNotes,
    bool isLoading = false,
    String? error,
    Filter? filter,
  }) {
    return NotesListState(
      allNotes: allNotes ?? this.allNotes,
      isLoading: isLoading,
      error: error,
      filter: filter ?? this.filter,
    );
  }

  @override
  List<Object?> get props => [allNotes, isLoading, error, filter];
}
