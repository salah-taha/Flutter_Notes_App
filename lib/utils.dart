import 'package:notes_repository/notes_repository.dart';
import 'package:notes_repository/repositories/local_notes_repository.dart';
import 'package:notes_repository/repositories/remote_notes_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum DataSourceType { remote, local }

Future<NotesRepository> getSavedDataSource() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? dataSourceType = prefs.getString('dataSourceType');
  if (dataSourceType == null) {
    return RemoteNotesRepository();
  }
  switch (dataSourceType) {
    case 'remote':
      return RemoteNotesRepository();
    case 'local':
      return LocalNotesRepository();
    default:
      return RemoteNotesRepository();
  }
}

Future<void> saveDataSourceType(DataSourceType dataSourceType) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  switch (dataSourceType) {
    case DataSourceType.remote:
      prefs.setString('dataSourceType', 'remote');
      break;
    case DataSourceType.local:
      prefs.setString('dataSourceType', 'local');
      break;
  }
}
