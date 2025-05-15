class Task {
  String id;
  String title;
  String description;
  String assignedTo;
  String status;
  DateTime dueDate;
  String taskType; // <--- Add this

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.assignedTo,
    required this.status,
    required this.dueDate,
    this.taskType = 'Ongoing',
  });

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      assignedTo: map['assignedTo'],
      status: map['status'],
      dueDate: DateTime.parse(map['dueDate']),
      taskType: map['taskType'] ?? 'Ongoing',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'assignedTo': assignedTo,
      'status': status,
      'dueDate': dueDate.toIso8601String(),
      'taskType': taskType,
    };
  }
}
