import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/task_model.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final FirebaseService firebaseService;
  final VoidCallback onStatusChanged;

  const TaskCard({
    Key? key,
    required this.task,
    required this.firebaseService,
    required this.onStatusChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(task.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Due: ${task.dueDate.toLocal().toString().split(' ')[0]}"),
            Text("Status: ${task.status}"),
            DropdownButton<String>(
              value: task.status,
              onChanged: (newStatus) async {
                if (newStatus != null) {
                  await firebaseService.updateTaskStatus(task.id, newStatus);
                  onStatusChanged(); // Notify parent to reload
                }
              },
              items: ['Starting', 'Running', 'Completed', 'Cancelled']
                  .map((status) => DropdownMenuItem(
                value: status,
                child: Text(status),
              ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
