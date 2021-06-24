import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/bloc/notes_bloc.dart';
import 'package:notes_app/screens/card_details.dart';
import 'package:flutter/foundation.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final iconList = <IconData>[
    Icons.home,
    Icons.delete,
  ];
  final labelList = ['Home', 'Trash'];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0)
      BlocProvider.of<NotesBloc>(context).add(GetAllEvent());
    else
      BlocProvider.of<NotesBloc>(context).add(GetTrashEvent());
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<NotesBloc>(context).add(GetAllEvent());
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black87,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              widget.title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 50),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: BlocBuilder<NotesBloc, NotesState>(
                  builder: (context, state) {
                    if (state is LoadingState)
                      return Center(child: CircularProgressIndicator());
                    else if (state is GetState)
                      return ListView.builder(
                          itemCount: state.notes.length,
                          itemBuilder: (context, i) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CardDetails(
                                        index: _selectedIndex,
                                        title: state.notes[i].title,
                                        desc: state.notes[i].desc,
                                        id: state.notes[i].id,
                                      ),
                                    ),
                                  );
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        20), // if you need this
                                    side: BorderSide(
                                      color: Colors.grey.withOpacity(0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8.0, bottom: 8.0),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            state.notes[i].title,
                                            style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            state.notes[i].desc,
                                            style: TextStyle(fontSize: 20),
                                            maxLines: 2,
                                          )
                                        ]),
                                  ),
                                ),
                              ),
                            );
                          });
                    else
                      return Center(child: Text('Error loading Data'));
                  },
                ),
              ),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/add');
            },
            child: Icon(Icons.add),
          ),
          bottomNavigationBar: AnimatedBottomNavigationBar.builder(
            itemCount: iconList.length,
            tabBuilder: (int index, bool isActive) {
              final color = isActive ? Colors.blue : Colors.black;
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    iconList[index],
                    size: 24,
                    color: color,
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: AutoSizeText(
                      labelList[index],
                      maxLines: 1,
                      style: TextStyle(color: color),
                    ),
                  )
                ],
              );
            },
            backgroundColor: Colors.white,
            activeIndex: _selectedIndex,
            splashColor: Colors.blue,
            splashSpeedInMilliseconds: 300,
            notchSmoothness: NotchSmoothness.defaultEdge,
            gapLocation: GapLocation.center,
            leftCornerRadius: 32,
            rightCornerRadius: 32,
            onTap: (index) => _onItemTap(index),
          ),
        ),
      ),
    );
  }
}
