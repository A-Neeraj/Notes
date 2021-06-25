import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes_app/bloc/notes_bloc.dart';
import 'package:notes_app/card_data.dart';
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
                      return StaggeredGridView.countBuilder(
                        crossAxisCount: 4,
                        // mainAxisExtent:
                        //     MediaQuery.of(context).size.height * 0.2),
                        itemCount: state.notes.length,
                        itemBuilder: (context, i) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, right: 5.0, left: 5.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/details',
                                    arguments: CardData(
                                        state.notes[i].title,
                                        state.notes[i].desc,
                                        state.notes[i].id,
                                        _selectedIndex));
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
                                        AutoSizeText(
                                          state.notes[i].title,
                                          maxLines: 1,
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
                        },
                        staggeredTileBuilder: (int index) =>
                            new StaggeredTile.fit(2),
                        mainAxisSpacing: 2.0,
                        crossAxisSpacing: 0,
                      );
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
