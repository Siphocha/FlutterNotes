// note_repository_impl.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutternotes/notes/note_data.dart';
import '../../notes/note_repo.dart';
import '../notes/note_model.dart';

class NoteRepositoryImpl implements NoteRepository {
  //all notes data is added into firestore, these are the vars for them.
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  NoteRepositoryImpl({
    //required name declarations.
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  }) : _firestore = firestore,
       _auth = auth;

  @override
  Future<List<Note>> fetchNotes() async {
    //If they not authenticated...get rid of em.
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final snapshot =
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('notes')
            .orderBy('createdAt', descending: true)
            .get();

    return snapshot.docs.map((doc) => NoteModel.fromFirestore(doc)).toList();
  }

  @override
  Future<void> addNote(String text) async {
    //adding note once authenticated thoroughly.
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('notes')
        .add(NoteModel(text: text, createdAt: DateTime.now()).toFirestore());
  }

  @override
  Future<void> updateNote(String id, String text) async {
    //updating note once authenticated.
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('notes')
        .doc(id)
        .update({'text': text});
  }

  @override
  Future<void> deleteNote(String id) async {
    //deleting note once authenticated.
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('notes')
        .doc(id)
        .delete();
  }
}
