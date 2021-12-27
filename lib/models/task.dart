

class Task {
  int? id;
  String? title;
  String? description;

  Task({
    this.id,
    this.title,
    this.description,
  });

  Task.fromMap(Map map) :
        this.id = map['id'],
        this.title = map['title'],
        this.description = map['description'];

  Map toMap(){
    return {
      'id': this.id,
      'title': this.title,
      'description': this.description,
    };
  }
}