part of 'app_bloc.dart';

abstract class AppEvent {}

class DataSourceChanged extends AppEvent {
  DataSourceChanged(this.dataSource);

  final DataSourceType dataSource;
}
