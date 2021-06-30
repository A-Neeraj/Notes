part of 'notes_bloc.dart';

@immutable
abstract class NotesState {}

class InitState extends NotesState {}

class LoadingState extends NotesState {}

class AddState extends NotesState {}

// ignore: must_be_immutable
class GetState extends NotesState {
  List<NotesModel> notes;
  GetState({this.notes});
}

class DeleteState extends NotesState {}

class UpdateState extends NotesState {}

class RestoreState extends NotesState {}

class DeleteForeverState extends NotesState {}

class UploadVideoState extends NotesState {}

class DisconnectedState extends NotesState {}
