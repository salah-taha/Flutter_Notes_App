import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/add_note/cubit/add_note_cubit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notes_repository/notes_repository.dart';

class AddNoteScreen extends StatelessWidget {
  const AddNoteScreen({super.key, this.noteId});
  final String? noteId;

  static Route route({String? noteId}) {
    return MaterialPageRoute<void>(
        builder: (_) => AddNoteScreen(noteId: noteId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final notesRepository = context.read<NotesRepository>();
        final cubit = AddNoteCubit(notesRepository);
        if (noteId != null) {
          cubit.loadNote(noteId!);
        }
        return cubit;
      },
      child: const AddNoteView(),
    );
  }
}

class AddNoteView extends StatefulWidget {
  const AddNoteView({super.key});

  @override
  State<AddNoteView> createState() => _AddNoteViewState();
}

class _AddNoteViewState extends State<AddNoteView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var users = context.read<NotesRepository>().getAllUsers();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: BlocListener<AddNoteCubit, AddNoteState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == FormStatus.submitting) {
            Fluttertoast.showToast(
                msg: state.noteId == null ? 'Submitting Note' : 'Updating Note',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0);
          } else if (state.status == FormStatus.success) {
            Fluttertoast.showToast(
                msg: state.noteId == null
                    ? 'Note Added Successfully'
                    : 'Note Updated Successfuly',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0);

            Navigator.of(context).pop();
          } else if (state.status == FormStatus.failure) {
            Fluttertoast.showToast(
                msg: state.error.toString(),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        },
        child: BlocBuilder<AddNoteCubit, AddNoteState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: Text(state.noteId == null ? 'Add Note' : 'Edit Note'),
                centerTitle: false,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.save),
                    onPressed: state.status == FormStatus.submitting
                        ? null
                        : () {
                            context.read<AddNoteCubit>().saveNote();
                          },
                  ),
                ],
              ),
              body: state.status == FormStatus.loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        TextFormField(
                          initialValue: state.note,
                          decoration: const InputDecoration(
                            labelText: 'Note',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 8,
                          onChanged: (value) =>
                              context.read<AddNoteCubit>().noteChanged(value),
                        ),
                        const SizedBox(height: 16),
                        if (users.isEmpty)
                          Row(
                            children: const [
                              // warning icon
                              Icon(Icons.warning_amber_rounded,
                                  color: Colors.red),
                              // show warning message
                              Text(
                                'You should add users first',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        DropdownButtonFormField<String>(
                          value: state.userId,
                          decoration: const InputDecoration(
                            labelText: 'Assign To User',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.purple,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select User';
                            }
                            return null;
                          },
                          items: context
                              .read<NotesRepository>()
                              .getAllUsers()
                              .map((e) => DropdownMenuItem(
                                    value: e.id,
                                    child: Text(e.username ?? e.email ?? e.id),
                                  ))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              context
                                  .read<AddNoteCubit>()
                                  .assignedUserCnaged(val);
                            }
                          },
                        ),
                      ],
                    ),
            );
          },
        ),
      ),
    );
  }
}
