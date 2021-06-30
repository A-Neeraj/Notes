import 'dart:async';
import 'dart:io';

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
      yield LoadingState();
      var url;
      if (event.imageFile != null)
        url = await repo.uploadVideo(event.fileName, event.imageFile);
      else
        url = null;
      var conn = await repo.addNotes(
          NotesModel(title: event.title, desc: event.desc, videoUrl: url));
      if (conn)
        yield AddState();
      else
        yield DisconnectedState();
    } else if (event is DeleteEvent) {
      var conn = await repo.deleteNotes(
          NotesModel(
              title: event.title, desc: event.desc, videoUrl: event.videoUrl),
          event.id);
      if (conn)
        yield DeleteState();
      else
        yield DisconnectedState();
    } else if (event is GetTrashEvent) {
      yield LoadingState();
      var notes = await repo.getNotes('trash');
      yield GetState(notes: notes);
    } else if (event is UpdateEvent) {
      yield LoadingState();
      var conn = await repo.updateNotes(
          NotesModel(
              title: event.title, desc: event.desc, videoUrl: event.videoUrl),
          event.id);
      if (conn)
        yield UpdateState();
      else
        yield DisconnectedState();
    } else if (event is DeleteForeverEvent) {
      var conn = await repo.deleteForever(event.id);
      if (conn)
        yield DeleteForeverState();
      else
        yield DisconnectedState();
    } else if (event is RestoreEvent) {
      var conn = await repo.restoreNote(
          NotesModel(
              title: event.title, desc: event.desc, videoUrl: event.videoUrl),
          event.id);
      if (conn)
        yield RestoreState();
      else
        yield DisconnectedState();
    }
  }
}
