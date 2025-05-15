import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_service.dart';
import '../models/task_model.dart';

class EmployeeTaskListScreen extends StatefulWidget {
  const EmployeeTaskListScreen({super.key});

  @override
  State<EmployeeTaskListScreen> createState() => _EmployeeTaskListScreenState();
}

class _EmployeeTaskListScreenState extends State<EmployeeTaskListScreen>
    with SingleTickerProviderStateMixin {
  final _firebaseService = FirebaseService();
  List<Task> _tasks = [];
  bool _isLoading = true;

  int totalTasks = 0;
  int runningTasks = 0; // In Progress
  int pendingTasks = 0; // Pending
  int deletedTasks = 0; // Deleted

  double progressPercent = 0.0;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final tasks = await _firebaseService.getTasksForEmployee(user.uid);

    setState(() {
      _tasks = tasks;
      _isLoading = false;

      _recalculateCounts();
    });
  }

  void _recalculateCounts() {
    totalTasks = _tasks.length;
    runningTasks = _tasks.where((t) => t.status == 'In Progress').length;
    pendingTasks = _tasks.where((t) => t.status == 'Pending').length;
    deletedTasks = _tasks.where((t) => t.status == 'Deleted').length;

    int completedTasks = _tasks.where((t) => t.status == 'Completed').length;

    progressPercent = totalTasks == 0 ? 0 : (completedTasks / totalTasks);
  }

  Future<void> _updateStatus(Task task) async {
    final statuses = ['Pending', 'In Progress', 'Completed', 'Deleted'];
    final currentIndex = statuses.indexOf(task.status);
    final nextIndex = (currentIndex + 1) % statuses.length;
    final newStatus = statuses[nextIndex];

    await _firebaseService.updateTaskStatus(task.id, newStatus);

    setState(() {
      task.status = newStatus;
      _recalculateCounts();
    });
  }

  Widget _buildTaskCard(Task task) {
    return Card(
      child: ListTile(
        title: Text(task.title),
        subtitle: Text(
            "Due: ${task.dueDate.toLocal().toString().split(' ')[0]} | Status: ${task.status}"),
        trailing: IconButton(
          icon: const Icon(Icons.update),
          onPressed: () => _updateStatus(task),
          tooltip: "Update Status",
        ),
      ),
    );
  }

  Widget _infoBox(String title, int count, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(title,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(count.toString(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Tasks")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          const SizedBox(height: 12),
          Row(
            children: [
              _infoBox('Total Tasks', totalTasks, Colors.blue),
              _infoBox('Running', runningTasks, Colors.orange),
              _infoBox('Pending', pendingTasks, Colors.purple),
              _infoBox('Deleted', deletedTasks, Colors.red),
            ],
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Progress',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                TweenAnimationBuilder<double>(
                  tween:
                  Tween<double>(begin: 0, end: progressPercent),
                  duration: const Duration(milliseconds: 500),
                  builder: (context, value, _) {
                    return LinearProgressIndicator(
                      value: value,
                      backgroundColor: Colors.grey[300],
                      color: Colors.green,
                      minHeight: 10,
                    );
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  '${(progressPercent * 100).toStringAsFixed(1)}% completed',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _tasks.isEmpty
                ? const Center(child: Text("No tasks assigned."))
                : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (ctx, index) =>
                  _buildTaskCard(_tasks[index]),
            ),
          ),
        ],
      ),
    );
  }
}
