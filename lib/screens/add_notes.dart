import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes_app/bloc/notes_bloc.dart';
import 'package:path/path.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({key}) : super(key: key);

  @override
  _AddNotesState createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  String title, desc, url;
  bool isActive = false;
  var formKey = GlobalKey<FormState>();

  final picker = ImagePicker();

  var videopath;
  File _videoFile;

  Future pickImage() async {
    final pickedFile = await picker.getVideo(source: ImageSource.gallery);
    // getImage(source: ImageSource.gallery);

    setState(() {
      _videoFile = File(
        pickedFile.path,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[700],
        title: Text('Add Note'),
      ),
      body: BlocConsumer<NotesBloc, NotesState>(listener: (context, state) {
        if (state is AddState) {
          BlocProvider.of<NotesBloc>(context).add(GetAllEvent());
          Navigator.pop(context);
        }
      }, builder: (context, state) {
        if (state is LoadingState)
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  'Please wait while your note is being added',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        else
          return Padding(
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
                          Row(children: [
                            Checkbox(
                              activeColor: Colors.white,
                              checkColor: Colors.black,
                              fillColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white),
                              value: isActive,
                              onChanged: (bool val) {
                                setState(() {
                                  isActive = val;
                                });
                              },
                            ),
                            Text(
                              'I have a video to upload',
                              style: TextStyle(
                                  color: Colors.grey[400], fontSize: 20),
                            ),
                          ]),
                          (isActive)
                              ? ElevatedButton(
                                  onPressed: () async {
                                    pickImage();
                                  },
                                  child: Text('Upload Video'))
                              : SizedBox()
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          BlocProvider.of<NotesBloc>(context).add(AddEvent(
                              title: title,
                              desc: desc,
                              fileName: (_videoFile) != null
                                  ? basename(_videoFile.path)
                                  : null,
                              imageFile: _videoFile));
                        }
                      },
                      child: Text('Add Note')),
                  (isLoading)
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : SizedBox()
                ],
              ),
            ),
          );
      }),
    );
  }
}
