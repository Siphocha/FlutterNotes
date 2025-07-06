// note_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../notes/note_data.dart';
import '../notes/notes_bloc.dart';
import 'note_dialog.dart';

class NoteCard extends StatelessWidget {
  final Note note;

  const NoteCard({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Card(
      //displaging the info in the card styling...for obvious reasons.
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(note.text, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text(
              'Created: ${note.createdAt.toString()}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => NoteDialog(note: note),
                    );
                  },
                ),
                IconButton(
                  //DELETTTEEE ITTTT! DELLLLLEETTE IT!
                  icon: const Icon(Icons.delete, size: 20),
                  onPressed: () {
                    _deleteNote(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _deleteNote(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Note'),
            content: const Text('You sure bud?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Stop'),
              ),
              TextButton(
                onPressed: () {
                  context.read<NotesBloc>().add(DeleteNote(note.id!));
                  Navigator.pop(context);
                },
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }
}
