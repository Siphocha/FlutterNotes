// note_repository.dart
import '../../notes/note_data.dart';

abstract class NoteRepository {
  //abstract class for holding the id and text associated with the ID.
  Future<List<Note>> fetchNotes();
  Future<void> addNote(String text);
  Future<void> updateNote(String id, String text);
  Future<void> deleteNote(String id);
}
