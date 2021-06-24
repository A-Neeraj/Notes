import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/bloc/notes_bloc.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({key}) : super(key: key);

  @override
  _AddNotesState createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  var title = TextEditingController();
  var desc = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add Note'),
      ),
      body: BlocListener<NotesBloc, NotesState>(
        listener: (context, state) {
          if (state is AddState) {
            BlocProvider.of<NotesBloc>(context).add(GetAllEvent());
            Navigator.pop(context);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: title,
                decoration: InputDecoration(
                    hintText: 'Enter Note Title', labelText: 'Title'),
              ),
              TextFormField(
                controller: desc,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                    hintText: 'Enter Note Description',
                    labelText: 'Description'),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<NotesBloc>(context)
                        .add(AddEvent(title: title.text, desc: desc.text));
                  },
                  child: Text('Add Note'))
            ],
          ),
        ),
      ),
    );
  }
}
