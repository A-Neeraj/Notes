import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'notes_model.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

class NotesRepository {
  var db = FirebaseFirestore.instance.collection("notes");
  var db1 = FirebaseFirestore.instance.collection("trash");
  addNotes(NotesModel notes) async {
    bool isConnected = true;
    try {
      http.Response response =
          await http.get(Uri.parse('https://www.google.com'));
    } on SocketException catch (e) {
      isConnected = false;
    }
    if (isConnected) db.add(notes.toMap());
    return isConnected;
  }

  Future<List<NotesModel>> getNotes(String type) async {
    if (type == 'all') {
      var notes;
      try {
        http.Response response =
            await http.get(Uri.parse('https://www.google.com'));
      } on SocketException catch (e) {
        List<Map<String, dynamic>> queryrows =
            await DatabaseHelper.instance.queryAll1();
        notes = queryrows.map((e) => NotesModel.fromMap(e, e['id'])).toList();
        print(notes);
      }
      if (notes == null) {
        var data = await db.get();
        notes = data.docs
            .map((note) => NotesModel.fromMap(note.data(), note.id))
            .toList();
        DatabaseHelper.instance.delete1();
        for (var note in notes)
          DatabaseHelper.instance.insert1({
            DatabaseHelper.columnDesc: note.desc,
            DatabaseHelper.columnTitle: note.title
          });
      }
      return notes;
    } else {
      var notes;
      try {
        http.Response response =
            await http.get(Uri.parse('https://www.google.com'));
      } on SocketException catch (e) {
        List<Map<String, dynamic>> queryrows =
            await DatabaseHelper.instance.queryAll2();
        notes = queryrows.map((e) => NotesModel.fromMap(e, e['id'])).toList();
        print(notes);
      }
      if (notes == null) {
        var data = await db1.get();
        notes = data.docs
            .map((note) => NotesModel.fromMap(note.data(), note.id))
            .toList();
        DatabaseHelper.instance.delete2();
        for (var note in notes)
          DatabaseHelper.instance.insert2({
            DatabaseHelper.columnDesc: note.desc,
            DatabaseHelper.columnTitle: note.title
          });
      }
      return notes;
    }
  }

  deleteNotes(NotesModel notes, var id) async {
    bool isConnected = true;
    try {
      http.Response response =
          await http.get(Uri.parse('https://www.google.com'));
    } on SocketException catch (e) {
      isConnected = false;
    }
    if (isConnected) {
      db1.add(notes.toMap());
      db.doc(id).delete();
    }
    return isConnected;
  }

  updateNotes(NotesModel notes, var id) async {
    bool isConnected = true;
    try {
      http.Response response =
          await http.get(Uri.parse('https://www.google.com'));
    } on SocketException catch (e) {
      isConnected = false;
    }
    if (isConnected) await db.doc(id).update(notes.toMap());
    return isConnected;
  }

  deleteForever(var id) async {
    bool isConnected = true;
    try {
      http.Response response =
          await http.get(Uri.parse('https://www.google.com'));
    } on SocketException catch (e) {
      isConnected = false;
    }
    if (isConnected) db1.doc(id).delete();
    return isConnected;
  }

  restoreNote(NotesModel notes, var id) async {
    bool isConnected = true;
    try {
      http.Response response =
          await http.get(Uri.parse('https://www.google.com'));
    } on SocketException catch (e) {
      isConnected = false;
    }
    if (isConnected) {
      db.add(notes.toMap());
      db1.doc(id).delete();
    }
    return isConnected;
  }

  uploadVideo(String fileName, File _imageFile) async {
    var imgpath;
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    await taskSnapshot.ref.getDownloadURL().then((value) {
      imgpath = value;
    });
    return imgpath;
  }
}
