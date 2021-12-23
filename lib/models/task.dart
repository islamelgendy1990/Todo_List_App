

class Task {
  String? title;
  String? description;

  Task({
    this.title,
    this.description,
  });

  Task.fromMap(Map map) :
        this.title = map['title'],
        this.description = map['description'];

  Map toMap(){
    return {
      'title': this.title,
      'description': this.description,
    };
  }
}