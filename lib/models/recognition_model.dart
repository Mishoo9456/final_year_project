import 'package:cloud_firestore/cloud_firestore.dart';

class Recognition {
  final String id;
  final String employeeId;
  final String title;
  final String description; // ✅ ADD THIS LINE
  final DateTime date;

  Recognition({
    required this.id,
    required this.employeeId,
    required this.title,
    required this.description, // ✅ ADD THIS LINE
    required this.date,
  });

  factory Recognition.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Recognition(
      id: doc.id,
      employeeId: data['employeeId'],
      title: data['title'],
      description: data['description'] ?? '', // ✅ HANDLE NULL SAFELY
      date: (data['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'employeeId': employeeId,
      'title': title,
      'description': description,
      'date': date,
    };
  }
}
