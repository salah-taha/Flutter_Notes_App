import 'package:dio/dio.dart';
import 'package:notes_repository/exceptions/interest_exceptions.dart';
import 'package:notes_repository/exceptions/note_exceptions.dart';
import 'package:notes_repository/exceptions/user_exceptions.dart';
import 'package:notes_repository/notes_repository.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalNotesRepository implements NotesRepository {
  final List<User> _usersCache = [];
  final List<Interest> _interestsCache = [];

  late Database _database;

  @override
  Future<void> init() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'notes.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT, text TEXT, userId TEXT,placeDateTime DATETIME, FOREIGN KEY (userId) REFERENCES users(id))',
        );
        await db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, password TEXT, email TEXT, intrestId TEXT, imageAsBase64 TEXT, FOREIGN KEY (intrestId) REFERENCES interests(id))',
        );
        await db.execute(
          'CREATE TABLE interests(id INTEGER PRIMARY KEY AUTOINCREMENT , intrestText TEXT)',
        );
      },
      version: 2,
    );
    await insertDummyData();
    await _getAllInterests();
    await _getAllUsers();
  }

  Future<List<Interest>> _getAllInterests() async {
    try {
      final List<Map<String, dynamic>> maps =
          await _database.query('interests');
      _interestsCache.clear();
      _interestsCache.addAll(maps.map((e) => Interest.fromMap(e)));
      return _interestsCache;
    } on DioError catch (e) {
      throw GetAllInterestsException(e.message, e);
    }
  }

  Future<List<User>> _getAllUsers() async {
    try {
      final List<Map<String, dynamic>> maps = await _database.query('users');
      _usersCache.clear();
      _usersCache.addAll(maps.map((e) => User.fromMap(e)));
      return _usersCache;
    } on DioError catch (e) {
      throw GetAllUsersException(e.message, e);
    }
  }

  Future<void> insertDummyData() async {
    var interests = await _database.query('interests');
    if (interests.isEmpty) {
      await _database.insert(
        'interests',
        Interest(id: '1', interestText: 'Sport').toMap(),
      );
      await _database.insert(
        'interests',
        Interest(id: '2', interestText: 'Music').toMap(),
      );
      await _database.insert(
        'interests',
        Interest(id: '3', interestText: 'Movies').toMap(),
      );
    }
  }

  @override
  Future<void> clearNotes() async {
    try {
      await _database.delete('notes');
    } on DioError catch (e) {
      throw ClearNotesException(e.message, e);
    }
  }

  @override
  Future<void> deleteUser(User user) async {
    try {
      await _database.delete('users', where: 'id = ?', whereArgs: [user.id]);
    } on DioError catch (e) {
      throw DeleteUserException(e.message, e);
    }
  }

  @override
  List<Interest> getAllInterests() {
    return _interestsCache;
  }

  @override
  Future<List<Note>> getAllNotes() async {
    try {
      final List<Map<String, dynamic>> maps = await _database.query('notes');
      return maps.map((e) => Note.fromMap(e)).toList();
    } on DioError catch (e) {
      throw GetAllNotesException(e.message, e);
    }
  }

  @override
  List<User> getAllUsers() {
    return _usersCache;
  }

  @override
  Future<Note> getNoteById(String id) async {
    try {
      final List<Map<String, dynamic>> maps =
          await _database.query('notes', where: 'id = ?', whereArgs: [id]);
      return Note.fromMap(maps.first);
    } on DioError catch (e) {
      throw GetNoteByIdException(e.message, e);
    }
  }

  @override
  Future<void> insertNote(Note note) async {
    try {
      await _database.insert('notes', note.toMap());
    } on DioError catch (e) {
      throw InsertNoteException(e.message, e);
    }
  }

  @override
  Future<void> insertUser(User user) async {
    try {
      await _database.insert('users', user.toMap());
      await _getAllUsers();
    } on DioError catch (e) {
      throw InsertUserException(e.message, e);
    }
  }

  @override
  Future<void> updateNote(Note note) async {
    try {
      await _database
          .update('notes', note.toMap(), where: 'id = ?', whereArgs: [note.id]);
    } on DioError catch (e) {
      throw UpdateNoteException(e.message, e);
    }
  }
}
