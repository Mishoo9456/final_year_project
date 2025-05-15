import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/task_model.dart';
import '../models/employee_model.dart';
import '../models/recognition_model.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Task Methods
  Future<void> createTask(Task task) async {
    await _db.collection('tasks').doc(task.id).set(task.toMap());
  }

  /// Automatically assign task based on least workload
  Future<void> createTaskAutoAssign(Task task) async {
    final employeesSnapshot = await _db.collection('employees').get();
    final List<Employee> employees = employeesSnapshot.docs
        .map((doc) => Employee.fromMap(doc.data()))
        .toList();

    if (employees.isEmpty) {
      throw Exception("No employees found");
    }

    final employeeTaskCounts = <String, int>{};
    for (final emp in employees) {
      final tasksSnapshot = await _db
          .collection('tasks')
          .where('assignedTo', isEqualTo: emp.id)
          .get();
      employeeTaskCounts[emp.id] = tasksSnapshot.size;
    }

    final selectedEmployeeId = employeeTaskCounts.entries
        .reduce((a, b) => a.value <= b.value ? a : b)
        .key;

    final autoAssignedTask = Task(
      id: task.id,
      title: task.title,
      description: task.description,
      status: task.status,
      dueDate: task.dueDate,
      assignedTo: selectedEmployeeId,
    );

    await createTask(autoAssignedTask);
  }

  Future<void> updateTaskStatus(String taskId, String newStatus) async {
    await _db.collection('tasks').doc(taskId).update({'status': newStatus});
  }

  Future<List<Task>> getTasksForUser(String userId) async {
    final snapshot = await _db
        .collection('tasks')
        .where('assignedTo', isEqualTo: userId)
        .get();

    return snapshot.docs.map((doc) => Task.fromMap(doc.data())).toList();
  }

  ///  Get tasks for employee (used in employee task screen)
  Future<List<Task>> getTasksForEmployee(String employeeId) async {
    final snapshot = await _db
        .collection('tasks')
        .where('assignedTo', isEqualTo: employeeId)
        .get();

    return snapshot.docs.map((doc) => Task.fromMap(doc.data())).toList();
  }

  // Employee Methods
  Future<List<Employee>> getAllEmployees() async {
    final snapshot = await _db.collection('employees').get();
    return snapshot.docs.map((doc) => Employee.fromMap(doc.data())).toList();
  }

  Future<Employee?> getEmployeeById(String id) async {
    final doc = await _db.collection('employees').doc(id).get();
    if (doc.exists) {
      return Employee.fromMap(doc.data()!);
    }
    return null;
  }

  // Recognition Methods
  Future<void> createRecognition(Recognition recognition) async {
    await _db
        .collection('recognitions')
        .doc(recognition.id)
        .set(recognition.toMap());
  }

  Future<List<Recognition>> getRecognitionsForEmployee(String employeeId) async {
    final snapshot = await _db
        .collection('recognitions')
        .where('employeeId', isEqualTo: employeeId)
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => Recognition.fromFirestore(doc))
        .toList();
  }
}
