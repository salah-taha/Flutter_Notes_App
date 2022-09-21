// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_task/utils.dart';
import 'package:notes_repository/notes_repository.dart';
import 'package:notes_repository/repositories/local_notes_repository.dart';
import 'package:notes_repository/repositories/remote_notes_repository.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc(NotesRepository repository)
      : super(InitialAppState(dataSource: repository)) {
    on<DataSourceChanged>(_onDataSourceChanged);
  }

  void _onDataSourceChanged(
    DataSourceChanged event,
    Emitter<AppState> emit,
  ) async {
    try {
      emit(DataSourceChangeRequested(dataSource: state.dataSource));
      NotesRepository repository;
      switch (event.dataSource) {
        case DataSourceType.remote:
          repository = RemoteNotesRepository();
          break;
        case DataSourceType.local:
          repository = LocalNotesRepository();
          break;
      }
      await repository.init();
      await saveDataSourceType(event.dataSource);
      emit(DataSourceChangedSuccessfuly(dataSource: repository));
    } catch (e) {
      emit(ChangeDataSourceError(error: e.toString()));
    }
  }
}
