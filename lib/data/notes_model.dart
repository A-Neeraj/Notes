class NotesModel {
  String title;
  String desc;
  String id;

  NotesModel({this.title, this.desc});

  toMap() => {
        "title": title,
        "desc": desc,
      };

  NotesModel.fromMap(Map<String, dynamic> map, String id)
      : title = map["title"],
        desc = map["desc"],
        id = id;
}
