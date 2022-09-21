import 'package:flutter/material.dart';
import 'package:flutter_task/add_note/view/add_note_screen.dart';
import 'package:flutter_task/options/view/view.dart';
import 'package:notes_repository/notes_repository.dart';
import '../../add_user/view/add_user_screen.dart';
import '../bloc/notes_list_bloc.dart';
import '../widgets/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotesListScreen extends StatelessWidget {
  const NotesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          NotesListBloc(context.read<NotesRepository>())..add(LoadNotes()),
      child: const NotesListView(),
    );
  }
}

class NotesListView extends StatefulWidget {
  const NotesListView({
    Key? key,
  }) : super(key: key);

  @override
  State<NotesListView> createState() => _NotesListViewState();
}

class _NotesListViewState extends State<NotesListView> {
  bool isSearch = false;
  final TextEditingController _controller = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() {
          isSearch = false;
        });
        _controller.clear();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              Navigator.of(context).push(AddUserScreen.route());
            },
          ),
          // settings
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(OptionsScreen.route());
            },
          ),
          //clear
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () {
              context.read<NotesListBloc>().add(ClearAllNotes());
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).push(AddNoteScreen.route());
          if (mounted) {
            context.read<NotesListBloc>().add(LoadNotes());
          }
        },
      ),
      body: BlocBuilder<NotesListBloc, NotesListState>(
        builder: (context, state) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: RefreshIndicator(
              color: Colors.deepPurpleAccent,
              onRefresh: () async =>
                  context.read<NotesListBloc>().add(LoadNotes()),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // filter
                          PopupMenuButton(
                            icon: const Icon(
                              Icons.filter_list,
                              color: Colors.deepPurpleAccent,
                            ),
                            onSelected: (value) {
                              context
                                  .read<NotesListBloc>()
                                  .add(FilterByUser(value));
                            },
                            itemBuilder: (_) {
                              return context
                                  .read<NotesRepository>()
                                  .getAllUsers()
                                  .map((user) {
                                return PopupMenuItem(
                                  value: user,
                                  child: Text(user.username ?? 'unknown'),
                                );
                              }).toList();
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.search,
                              color: Colors.deepPurpleAccent,
                            ),
                            onPressed: () {
                              if (isSearch) {
                                setState(() {
                                  isSearch = false;
                                });
                                _controller.clear();
                                _focusNode.unfocus();
                              } else {
                                setState(() {
                                  isSearch = true;
                                });
                                _focusNode.requestFocus();
                              }
                            },
                          ),

                          isSearch
                              ? Expanded(
                                  child: SizedBox(
                                    height: 40,
                                    child: TextField(
                                      // cursorHeight: 10,
                                      style: const TextStyle(height: 1.5),
                                      controller: _controller,
                                      focusNode: _focusNode,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 10),
                                        // isDense: true,
                                        // isCollapsed: true,
                                        border: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.purple,
                                          ),
                                        ),
                                        suffix: GestureDetector(
                                          onTap: () {
                                            _controller.clear();
                                          },
                                          child: const Icon(
                                            Icons.clear,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      onSubmitted: (value) {
                                        context
                                            .read<NotesListBloc>()
                                            .add(FilterByTitle(value));
                                        _focusNode.unfocus();
                                      },
                                    ),
                                  ),
                                )
                              : Expanded(
                                  child: Row(
                                    children: [
                                      if (state.filter.user != null)
                                        Chip(
                                          label: Text(
                                              'User: ${state.filter.user!.username ?? 'unknown'}'),
                                          onDeleted: () {
                                            context
                                                .read<NotesListBloc>()
                                                .add(RemoveFilterByUser());
                                          },
                                        ),
                                      if (state.filter.text != null)
                                        Chip(
                                          label: Text(
                                              'Title: ${state.filter.text!}'),
                                          onDeleted: () {
                                            context
                                                .read<NotesListBloc>()
                                                .add(RemoveFilterByTitle());
                                          },
                                        ),
                                    ],
                                  ),
                                )
                        ],
                      ),
                    ),
                  ),
                  if (state.isLoading)
                    const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                    )
                  else if (state.error != null)
                    SliverFillRemaining(
                      child: Center(
                        child: Text(state.error!),
                      ),
                    )
                  else if (state.notes.isEmpty)
                    SliverFillRemaining(
                      child: Center(
                        child: Text('No notes ${state.filter.getText}'),
                      ),
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return NoteCard(note: state.notes[index]);
                        },
                        childCount: state.notes.length,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
