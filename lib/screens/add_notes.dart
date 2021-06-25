import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/bloc/notes_bloc.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({key}) : super(key: key);

  @override
  _AddNotesState createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  String title, desc;
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[700],
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
          child: SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                              hintText: "Enter note title",
                              labelText: "Title",
                              labelStyle: TextStyle(
                                  fontSize: 20, color: Colors.grey[500]),
                              hintStyle: TextStyle(
                                  fontSize: 32, color: Colors.grey[400])),
                          style: TextStyle(fontSize: 32, color: Colors.white),
                          onChanged: (val) {
                            title = val;
                          },
                          validator: (val) {
                            if (val.isEmpty)
                              return "Title can\'t be empty";
                            else
                              return null;
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                              hintText: 'Enter Note Description',
                              hintStyle: TextStyle(
                                  fontSize: 20, color: Colors.grey[400]),
                              labelStyle: TextStyle(color: Colors.grey[500]),
                              labelText: 'Note Description'),
                          style: TextStyle(fontSize: 20, color: Colors.white),
                          onChanged: (val) {
                            desc = val;
                          },
                          validator: (val) {
                            if (val.isEmpty)
                              return "Description can\'t be empty";
                            else
                              return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState.validate())
                        BlocProvider.of<NotesBloc>(context)
                            .add(AddEvent(title: title, desc: desc));
                    },
                    child: Text('Add Note'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
