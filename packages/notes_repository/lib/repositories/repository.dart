import 'package:notes_repository/notes_repository.dart';

abstract class NotesRepository {
  Future<void> init();
  Future<List<Note>> getAllNotes();
  List<User> getAllUsers();
  List<Interest> getAllInterests();
  Future<Note> getNoteById(String id);
  Future<void> updateNote(Note note);
  Future<void> insertNote(Note note);
  Future<void> clearNotes();
  Future<void> insertUser(User user);
  Future<void> deleteUser(User user);
}
