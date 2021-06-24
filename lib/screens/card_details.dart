import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/bloc/notes_bloc.dart';

class CardDetails extends StatefulWidget {
  final String title;
  final String desc;
  final String id;
  final int index;
  const CardDetails({key, this.title, this.desc, this.id, this.index})
      : super(key: key);

  @override
  _CardDetailsState createState() => _CardDetailsState();
}

class _CardDetailsState extends State<CardDetails> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocListener<NotesBloc, NotesState>(
          listener: (context, state) {
            if (state is DeleteState) {
              BlocProvider.of<NotesBloc>(context).add(GetAllEvent());
              Navigator.pop(context);
            }
          },
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: Colors.grey.withOpacity(0.2), width: 1),
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.blue,
                        Colors.red,
                      ],
                    )),
                height: MediaQuery.of(context).size.height * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        widget.title,
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 15.0),
                      child: Divider(
                        color: Colors.black,
                        thickness: 3,
                      ),
                    ),
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            bottom: 10.0, left: 10.0, right: 10.0),
                        child: Text(
                          widget.desc,
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                    Spacer(),
                    (widget.index == 0)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              // ElevatedButton.icon(
                              //     onPressed: () {},
                              //     icon: Icon(Icons.edit),
                              //     label: Text('Edit')),
                              RawMaterialButton(
                                onPressed: () {
                                  BlocProvider.of<NotesBloc>(context).add(
                                      DeleteEvent(
                                          id: widget.id,
                                          title: widget.title,
                                          desc: widget.desc));
                                },
                                elevation: 2.0,
                                fillColor: Colors.white,
                                child: Icon(
                                  Icons.delete,
                                  size: 35.0,
                                ),
                                padding: EdgeInsets.all(15.0),
                                shape: CircleBorder(),
                              ),
                            ],
                          )
                        : SizedBox(),
                    SizedBox(
                      height: 10,
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
