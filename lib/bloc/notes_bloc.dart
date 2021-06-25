import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:notes_app/data/notes_model.dart';
import 'package:notes_app/data/notes_repository.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  NotesRepository repo;
  NotesBloc(NotesState initialState, this.repo) : super(initialState);

  @override
  Stream<NotesState> mapEventToState(
    NotesEvent event,
  ) async* {
    if (event is GetAllEvent) {
      yield LoadingState();
      var notes = await repo.getNotes('all');
      yield GetState(notes: notes);
    } else if (event is AddEvent) {
      await repo.addNotes(NotesModel(title: event.title, desc: event.desc));
      yield AddState();
    } else if (event is DeleteEvent) {
      await repo.deleteNotes(
          NotesModel(title: event.title, desc: event.desc), event.id);
      yield DeleteState();
    } else if (event is GetTrashEvent) {
      yield LoadingState();
      var notes = await repo.getNotes('trash');
      yield GetState(notes: notes);
    } else if (event is UpdateEvent) {
      yield LoadingState();
      await repo.updateNotes(
          NotesModel(title: event.title, desc: event.desc), event.id);
      yield UpdateState();
    }
  }
}
