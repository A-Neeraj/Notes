import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/bloc/notes_bloc.dart';
import 'package:notes_app/card_data.dart';

class CardDetails extends StatefulWidget {
  const CardDetails({key}) : super(key: key);

  @override
  _CardDetailsState createState() => _CardDetailsState();
}

class _CardDetailsState extends State<CardDetails> {
  String title, desc;
  var formKey = GlobalKey<FormState>();
  bool edit = false;

  @override
  Widget build(BuildContext context) {
    CardData cd = ModalRoute.of(context).settings.arguments;
    title = cd.title;
    desc = cd.desc;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      floatingActionButton: edit
          ? FloatingActionButton(
              onPressed: () {
                if (formKey.currentState.validate())
                  BlocProvider.of<NotesBloc>(context)
                      .add(UpdateEvent(id: cd.id, title: title, desc: desc));
                setState(() {
                  edit = false;
                });
              },
              child: Icon(
                Icons.save,
                color: Colors.white,
              ),
            )
          : null,
      body: BlocListener<NotesBloc, NotesState>(
        listener: (context, state) {
          if (state is DeleteState) {
            BlocProvider.of<NotesBloc>(context).add(GetAllEvent());
            BlocProvider.of<NotesBloc>(context).add(GetAllEvent());
            Navigator.pop(context);
          }
          if (state is UpdateState) {
            BlocProvider.of<NotesBloc>(context).add(GetAllEvent());
          }
          if (state is DeleteForeverState) {
            Navigator.pop(context);
            BlocProvider.of<NotesBloc>(context).add(GetTrashEvent());
            BlocProvider.of<NotesBloc>(context).add(GetTrashEvent());
          }
          if (state is RestoreState) {
            BlocProvider.of<NotesBloc>(context).add(GetTrashEvent());
            Navigator.pop(context);
            BlocProvider.of<NotesBloc>(context).add(GetTrashEvent());
          }
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border:
                      Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.blue,
                      Colors.red,
                    ],
                  )),
              height: MediaQuery.of(context).size.height * 0.65,
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                focusedBorder: InputBorder.none,
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                              initialValue: cd.title,
                              enabled: edit,
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
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Divider(
                            color: Colors.black,
                            thickness: 3,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 10.0, left: 10.0, right: 10.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.35,
                            child: SingleChildScrollView(
                              child: TextFormField(
                                decoration:
                                    InputDecoration(border: InputBorder.none),
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                enabled: edit,
                                initialValue: cd.desc,
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
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
                            ),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    (cd.index == 0)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              RawMaterialButton(
                                onPressed: () {
                                  setState(() {
                                    edit = !edit;
                                  });
                                },
                                elevation: 2.0,
                                fillColor: Colors.grey[400],
                                child: Icon(
                                  Icons.edit,
                                  size: 35.0,
                                ),
                                padding: EdgeInsets.all(10.0),
                                shape: CircleBorder(),
                              ),
                              RawMaterialButton(
                                onPressed: () {
                                  BlocProvider.of<NotesBloc>(context).add(
                                      DeleteEvent(
                                          id: cd.id,
                                          title: cd.title,
                                          desc: cd.desc));
                                },
                                elevation: 2.0,
                                fillColor: Colors.red,
                                child: Icon(
                                  Icons.delete,
                                  size: 35.0,
                                ),
                                padding: EdgeInsets.all(10.0),
                                shape: CircleBorder(),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              RawMaterialButton(
                                onPressed: () {
                                  BlocProvider.of<NotesBloc>(context).add(
                                      RestoreEvent(
                                          id: cd.id,
                                          title: cd.title,
                                          desc: cd.desc));
                                },
                                elevation: 2.0,
                                fillColor: Colors.green,
                                child: Icon(
                                  Icons.restore_from_trash_rounded,
                                  size: 35.0,
                                ),
                                padding: EdgeInsets.all(15.0),
                                shape: CircleBorder(),
                              ),
                              RawMaterialButton(
                                onPressed: () {
                                  BlocProvider.of<NotesBloc>(context)
                                      .add(DeleteForeverEvent(
                                    id: cd.id,
                                  ));
                                },
                                elevation: 2.0,
                                fillColor: Colors.red,
                                child: Icon(
                                  Icons.delete_forever,
                                  size: 35.0,
                                ),
                                padding: EdgeInsets.all(15.0),
                                shape: CircleBorder(),
                              ),
                            ],
                          ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
