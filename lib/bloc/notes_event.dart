part of 'notes_bloc.dart';

@immutable
abstract class NotesEvent {}

// ignore: must_be_immutable
class AddEvent extends NotesEvent {
  String title;
  String desc;
  AddEvent({this.title, this.desc});
}

class GetAllEvent extends NotesEvent {}

class GetTrashEvent extends NotesEvent {}

// ignore: must_be_immutable
class DeleteEvent extends NotesEvent {
  String id;
  String title;
  String desc;
  DeleteEvent({this.title, this.desc, this.id});
}

// ignore: must_be_immutable
class UpdateEvent extends NotesEvent {
  String id;
  String title;
  String desc;
  UpdateEvent({this.title, this.desc, this.id});
}

class RestoreEvent extends NotesEvent {
  String id;
  String title;
  String desc;
  RestoreEvent({this.title, this.desc, this.id});
}

class DeleteForeverEvent extends NotesEvent {
  String id;
  DeleteForeverEvent({this.id});
}
