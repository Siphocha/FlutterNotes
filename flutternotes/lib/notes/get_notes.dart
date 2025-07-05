// get_notes.dart
import '../notes/note_data.dart';
import '../notes/note_repo.dart';

class GetNotes {
  //class to retrieve notes. Class because its easier to call around as a data type.
  final NoteRepository repository;

  GetNotes(this.repository);

  Future<List<Note>> call() async {
    return await repository.fetchNotes();
  }
}
