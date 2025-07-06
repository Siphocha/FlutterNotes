// home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutternotes/authLogic/auth_event.dart';
import '../authLogic/auth_bloc.dart';
import '../notes/notes_bloc.dart';
import '../widgets/note_card.dart';
import '../widgets/note_dialog.dart';

class HomePage extends StatelessWidget {
  //HomePage is stateless because the overall design doesnt change.
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Tracking!'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
            },
          ),
        ],
      ),
      //Have to have a dedicated action bar
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const NoteDialog(),
          );
        },
      ),

      body: BlocConsumer<NotesBloc, NotesState>(
        listener: (context, state) {
          if (state.status == NotesStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Error')),
            );
          }
        },
        builder: (context, state) {
          if (state.status == NotesStatus.initial ||
              state.status == NotesStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          //Incase nothing written, warn them to make something
          if (state.notes.isEmpty) {
            return const Center(
              child: Text('Nothing here yet—tap ➕ to add a note.'),
            );
          }

          //Display them all in the listview type when they're made.
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: state.notes.length,
            itemBuilder: (context, index) {
              final note = state.notes[index];
              return NoteCard(note: note);
            },
          );
        },
      ),
    );
  }
}
