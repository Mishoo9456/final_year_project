import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';
import '../models/employee_model.dart';

class AssignmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> autoAssignTask(Task task) async {
    final employeesSnapshot = await _firestore.collection('employees').get();

    List<Employee> employees = employeesSnapshot.docs.map((doc) {
      return Employee.fromMap(doc.data());
    }).toList();

    employees.sort((a, b) => a.workload.compareTo(b.workload));

    if (employees.isNotEmpty) {
      final bestEmployee = employees.first;

      Task updatedTask = Task(
        id: task.id,
        title: task.title,
        description: task.description,
        assignedTo: bestEmployee.id,
        status: task.status,
        dueDate: task.dueDate,
      );

      await _firestore.collection('tasks').doc(task.id).set(updatedTask.toMap());

      await _firestore
          .collection('employees')
          .doc(bestEmployee.id)
          .update({'workload': bestEmployee.workload + 1});
    }
  }
}
