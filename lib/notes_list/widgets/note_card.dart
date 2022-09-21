import 'package:flutter/material.dart';
import 'package:flutter_task/add_note/view/add_note_screen.dart';
import 'package:notes_repository/notes_repository.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({super.key, required this.note});

  final Note note;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  note.text ?? 'No text',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 32),
              // edit button
              IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: Colors.grey,
                ),
                onPressed: () {
                  Navigator.of(context)
                      .push(AddNoteScreen.route(noteId: note.id));
                },
              ),
            ],
          ),
        ),
        // divider
        const Divider(
          thickness: 2,
        ),
      ],
    );
  }
}
