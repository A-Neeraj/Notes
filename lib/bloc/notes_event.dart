part of 'notes_bloc.dart';

@immutable
abstract class NotesEvent {}

// ignore: must_be_immutable
class AddEvent extends NotesEvent {
  String title;
  String desc;
  String videoUrl;
  String fileName;
  File imageFile;
  AddEvent(
      {this.title, this.desc, this.videoUrl, this.fileName, this.imageFile});
}

class GetAllEvent extends NotesEvent {}

class DisconnectedEvent extends NotesEvent {}

class GetTrashEvent extends NotesEvent {}

// ignore: must_be_immutable
class DeleteEvent extends NotesEvent {
  String id;
  String title;
  String desc;
  String videoUrl;
  DeleteEvent({this.title, this.desc, this.id, this.videoUrl});
}

// ignore: must_be_immutable
class UpdateEvent extends NotesEvent {
  String id;
  String title;
  String desc;
  String videoUrl;
  UpdateEvent({this.title, this.desc, this.id, this.videoUrl});
}

class RestoreEvent extends NotesEvent {
  String id;
  String title;
  String desc;
  String videoUrl;
  RestoreEvent({this.title, this.desc, this.id, this.videoUrl});
}

class DeleteForeverEvent extends NotesEvent {
  String id;
  DeleteForeverEvent({this.id});
}

class UploadVideoEvent extends NotesEvent {
  String fileName;
  File imageFile;
  UploadVideoEvent({this.fileName, this.imageFile});
}
