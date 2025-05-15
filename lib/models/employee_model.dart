class Employee {
  final String id;
  final String name;
  final List<String> skills;
  final int workload;

  Employee({
    required this.id,
    required this.name,
    required this.skills,
    required this.workload,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'skills': skills,
      'workload': workload,
    };
  }

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'],
      name: map['name'],
      skills: List<String>.from(map['skills']),
      workload: map['workload'],
    );
  }
}
