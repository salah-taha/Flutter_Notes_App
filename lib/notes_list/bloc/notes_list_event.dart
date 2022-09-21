part of 'notes_list_bloc.dart';

abstract class NotesListEvent extends Equatable {}

class LoadNotes extends NotesListEvent {
  LoadNotes();

  @override
  List<Object?> get props => [];
}

class FilterByTitle extends NotesListEvent {
  FilterByTitle(this.title);

  final String title;

  @override
  List<Object?> get props => [title];
}

class FilterByUser extends NotesListEvent {
  FilterByUser(this.user);

  final User user;

  @override
  List<Object?> get props => [user];
}

class RemoveFilterByUser extends NotesListEvent {
  @override
  List<Object?> get props => [];
}

class RemoveFilterByTitle extends NotesListEvent {
  @override
  List<Object?> get props => [];
}

class ClearAllNotes extends NotesListEvent {
  @override
  List<Object?> get props => [];
}
