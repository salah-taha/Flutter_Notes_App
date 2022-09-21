part of 'app_bloc.dart';

abstract class AppState extends Equatable {
  const AppState({
    required this.dataSource,
  });

  final NotesRepository? dataSource;

  @override
  List<Object?> get props => [dataSource];
}

class InitialAppState extends AppState {
  const InitialAppState({
    required NotesRepository dataSource,
  }) : super(dataSource: dataSource);

  @override
  List<Object?> get props => [dataSource];
}

class ChangeDataSourceError extends AppState {
  const ChangeDataSourceError({
    required this.error,
  }) : super(dataSource: null);

  final String error;

  @override
  List<Object> get props => [error];
}

class DataSourceChangedSuccessfuly extends AppState {
  const DataSourceChangedSuccessfuly({
    required NotesRepository dataSource,
  }) : super(dataSource: dataSource);

  @override
  List<Object?> get props => [dataSource];
}

class DataSourceChangeRequested extends AppState {
  const DataSourceChangeRequested({required NotesRepository? dataSource})
      : super(dataSource: dataSource);

  @override
  List<Object?> get props => [dataSource];
}
