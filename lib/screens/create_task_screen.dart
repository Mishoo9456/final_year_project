import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/task_model.dart';
import '../services/firebase_service.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key, required void Function() onTaskCreated});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  DateTime? _selectedDate;
  String _selectedTaskType = 'Ongoing'; // Default type

  final _firebaseService = FirebaseService();

  void _submitTask() async {
    if (_titleController.text.isEmpty || _descController.text.isEmpty || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    final task = Task(
      id: const Uuid().v4(),
      title: _titleController.text,
      description: _descController.text,
      assignedTo: "", // Will be assigned in service
      status: "Starting",
      dueDate: _selectedDate!,
      taskType: _selectedTaskType, // Save selected type
    );

    await _firebaseService.createTaskAutoAssign(task);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Task created and assigned successfully!")),
    );

    Navigator.pop(context);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Task")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: "Task Title")),
            TextField(controller: _descController, decoration: const InputDecoration(labelText: "Description")),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(_selectedDate == null
                      ? "No Date Chosen"
                      : "Due: ${_selectedDate!.toLocal().toShortString()}"),
                ),
                TextButton(onPressed: _pickDate, child: const Text("Pick Date")),
              ],
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedTaskType,
              decoration: const InputDecoration(labelText: "Task Type"),
              items: ['Ongoing', 'Urgent'].map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedTaskType = value;
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _submitTask, child: const Text("Create Task")),
          ],
        ),
      ),
    );
  }
}

// Helper to format date
extension DateTimeExtension on DateTime {
  String toShortString() {
    return "${this.day}/${this.month}/${this.year}";
  }
}
