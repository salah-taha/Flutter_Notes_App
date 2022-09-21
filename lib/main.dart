import 'package:flutter/material.dart';
import 'package:flutter_task/utils.dart';
import 'package:notes_repository/notes_repository.dart';

import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // gets the saved data source type if the user has already selected one
  // else it will use the remote data source
  NotesRepository notesRepository = await getSavedDataSource();
  await notesRepository.init();
  runApp(App(
    notesRepository: notesRepository,
  ));
}
