import 'package:dio/dio.dart';
import 'package:notes_repository/exceptions/exceptions.dart';
import 'package:notes_repository/notes_repository.dart';

class RemoteNotesRepository implements NotesRepository {
  late Dio _client;

  List<User> _usersCache = [];
  List<Interest> _interestsCache = [];

  Future<void> init() async {
    _client = Dio(
      BaseOptions(
        baseUrl: 'https://noteapi.popssolutions.net',
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
    await _getAllUsers();
    await _getAllInterests();
  }

  @override
  Future<void> clearNotes() async {
    try {
      await _client.post('/notes/clear');
    } on DioError catch (e) {
      throw ClearNotesException(e.message, e);
    }
  }

  @override
  Future<void> deleteUser(User user) async {
    try {
      await _client.delete('/users/${user.id}');
    } on DioError catch (e) {
      throw DeleteUserException(e.message, e);
    }
  }

  Future<List<Interest>> _getAllInterests() async {
    try {
      final response = await _client.get('/intrests/getall');
      final interests = response.data as List;
      return _interestsCache =
          interests.map((e) => Interest.fromMap(e)).toList();
    } on DioError catch (e) {
      throw GetAllInterestsException(e.message, e);
    }
  }

  @override
  Future<List<Note>> getAllNotes() async {
    try {
      var response = await _client.get('/notes/getall');
      return (response.data as List).map((e) => Note.fromMap(e)).toList();
    } on DioError catch (e) {
      throw GetAllNotesException(e.message, e);
    }
  }

  Future<List<User>> _getAllUsers() async {
    try {
      var response = await _client.get('/users/getall');
      return _usersCache =
          (response.data as List).map((e) => User.fromMap(e)).toList();
    } on DioError catch (e) {
      throw GetAllUsersException(e.message, e);
    }
  }

  @override
  Future<Note> getNoteById(String id) async {
    try {
      var response = await _client.get('/notes/get/$id');
      return Note.fromMap(response.data);
    } on DioError catch (e) {
      throw GetNoteByIdException(e.message, e);
    }
  }

  @override
  Future<void> insertNote(Note note) async {
    try {
      await _client.post('/notes/insert', data: note.toJson());
    } on DioError catch (e) {
      throw InsertNoteException(e.message, e);
    }
  }

  @override
  Future<void> insertUser(User user) async {
    try {
      var response = await _client.post('/users/insert', data: user.toJson());
      if (response.statusCode == 200) {
        await _getAllUsers();
      }
    } on DioError catch (e) {
      throw InsertUserException(e.message, e);
    }
  }

  @override
  Future<void> updateNote(Note note) async {
    try {
      await _client.post('/notes/update', data: note.toJson());
    } on DioError catch (e) {
      throw UpdateNoteException(e.message, e);
    }
  }

  @override
  List<Interest> getAllInterests() {
    return _interestsCache;
  }

  @override
  List<User> getAllUsers() {
    return _usersCache;
  }
}
