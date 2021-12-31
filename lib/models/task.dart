

class Task {
  int? id;
  String? title;
  String? description;
  String? date;
  String? time;

  Task({
    this.id,
    this.title,
    this.description,
    this.date,
    this.time,
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
      'date': this.date,
      'time': this.time,
    };
  }
}