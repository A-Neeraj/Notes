class NotesModel {
  String title;
  String desc;
  String id;
  String videoUrl;

  NotesModel({this.title, this.desc, this.videoUrl});

  toMap() => {"title": title, "desc": desc, "videoUrl": videoUrl};

  NotesModel.fromMap(Map<String, dynamic> map, String id)
      : title = map["title"],
        desc = map["desc"],
        id = id,
        videoUrl = map["videoUrl"];
}
