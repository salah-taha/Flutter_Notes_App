import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/app/bloc/app_bloc.dart';
import 'package:flutter_task/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notes_repository/repositories/local_notes_repository.dart';

class OptionsScreen extends StatelessWidget {
  const OptionsScreen({super.key});

  // route
  static MaterialPageRoute route() {
    return MaterialPageRoute(
      builder: (context) => const OptionsScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Options'),
        centerTitle: false,
      ),
      body: BlocListener<AppBloc, AppState>(
        listenWhen: (previous, current) =>
            previous.dataSource != current.dataSource,
        listener: (context, state) {
          if (state is DataSourceChangedSuccessfuly) {
            Fluttertoast.showToast(
                msg: 'Data source changed successfully',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0);
          } else if (state is ChangeDataSourceError) {
            Fluttertoast.showToast(
                msg: 'Error changing data source',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            BlocBuilder<AppBloc, AppState>(
              builder: (context, state) {
                return ListTile(
                  title: const Text('Use Local Database'),
                  subtitle: const Text(
                      'Instead of using HTTP call to work with the app data, Please use SQLite for this'),
                  trailing: Switch(
                    value: state.dataSource is LocalNotesRepository,
                    onChanged: state is DataSourceChangeRequested
                        ? null
                        : (value) {
                            if (value) {
                              context
                                  .read<AppBloc>()
                                  .add(DataSourceChanged(DataSourceType.local));
                            } else {
                              context.read<AppBloc>().add(
                                  DataSourceChanged(DataSourceType.remote));
                            }
                          },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
