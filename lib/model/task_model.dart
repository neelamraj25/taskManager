class Task {
   String title;
   String description;
   String status;

  Task({required this.title, required this.description, required this.status});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'status': status,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map, String id) {
    return Task(
      title: map['title'],
      description: map['description'],
      status: map['status'],
    );
  }
}
