import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/bloc/notes_bloc.dart';
import 'package:notes_app/data/notes_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_app/screens/card_details.dart';
import 'package:notes_app/screens/play_video.dart';
import 'screens/add_notes.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings = Settings(persistenceEnabled: false);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotesBloc>(
      create: (context) => NotesBloc(InitState(), NotesRepository()),
      child: MaterialApp(
        title: 'Notes App',
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => MyHomePage(
                title: 'Notes',
              ),
          '/add': (context) => AddNotes(),
          '/details': (context) => CardDetails(),
          '/video': (context) => PlayVideo(),
        },
      ),
    );
  }
}
