import 'package:cloud_firestore/cloud_firestore.dart';
import 'notes_model.dart';

class NotesRepository {
  var db = FirebaseFirestore.instance.collection("notes");
  var db1 = FirebaseFirestore.instance.collection("trash");
  addNotes(NotesModel notes) {
    db.add(notes.toMap());
  }

  Future<List<NotesModel>> getNotes(String type) async {
    if (type == 'all') {
      var data = await db.get();
      var notes = data.docs
          .map((note) => NotesModel.fromMap(note.data(), note.id))
          .toList();
      return notes;
    } else {
      var data = await db1.get();
      var notes = data.docs
          .map((note) => NotesModel.fromMap(note.data(), note.id))
          .toList();
      return notes;
    }
  }

  deleteNotes(NotesModel notes, var id) {
    db1.add(notes.toMap());
    db.doc(id).delete();
  }

  updateNotes(NotesModel notes, var id) {
    print(notes.toMap());
    db.doc(id).set(notes.toMap());
  }
}
