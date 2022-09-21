import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_task/app/bloc/app_bloc.dart';
import 'package:flutter_task/notes_list/notes_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/theme/theme.dart';
import 'package:notes_repository/repositories/repository.dart';

class App extends StatelessWidget {
  const App({super.key, required this.notesRepository});

  final NotesRepository notesRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(notesRepository),
      child: const AppBody(),
    );
  }
}

class AppBody extends StatelessWidget {
  const AppBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return RepositoryProvider.value(
          value: state.dataSource,
          child: MaterialApp(
            theme: NotesAppTheme.light,
            title: 'Flutter Task',
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', 'US'),
            ],
            home: NotesListScreen(
              key: ValueKey(state.dataSource),
            ),
          ),
        );
      },
    );
  }
}
