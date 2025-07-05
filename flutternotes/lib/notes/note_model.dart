// note_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../notes/note_data.dart';

class NoteModel extends Note {
  //Data of which the note model will hold.
  NoteModel({String? id, required String text, required DateTime createdAt})
    : super(id: id, text: text, createdAt: createdAt);

  factory NoteModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NoteModel(
      //Order of data presentation on the notes.
      id: doc.id,
      text: data['text'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {'text': text, 'createdAt': Timestamp.fromDate(createdAt)};
  }
}
