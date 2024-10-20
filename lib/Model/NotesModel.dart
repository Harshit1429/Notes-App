class NotesModel {
  final int? id;

  final String title;

  final String description;

  NotesModel(
      { this.id, required this.title, required this.description});

  // map --> Model Class
  factory NotesModel.fromMap(Map<String, dynamic> map) {
    return NotesModel(
        id: map['id'], title: map['title'], description: map['description']);
  }

  // Model Class --> Map
   Map<String , Object> toMap(){
    return {
      'title' : title,
      'description' : description
    };
   }
}
