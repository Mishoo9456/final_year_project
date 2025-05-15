import 'package:flutter/material.dart';
import '../models/recognition_model.dart';
import '../services/firebase_service.dart';

class EmployeeRecognitionListScreen extends StatefulWidget {
  final String employeeId;

  const EmployeeRecognitionListScreen({super.key, required this.employeeId});

  @override
  State<EmployeeRecognitionListScreen> createState() =>
      _EmployeeRecognitionListScreenState();
}

class _EmployeeRecognitionListScreenState
    extends State<EmployeeRecognitionListScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  List<Recognition> _recognitions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecognitions();
  }

  Future<void> _loadRecognitions() async {
    final recognitions =
    await _firebaseService.getRecognitionsForEmployee(widget.employeeId);
    setState(() {
      _recognitions = recognitions;
      _isLoading = false;
    });
  }

  Widget _buildRecognitionCard(Recognition recognition) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 3,
      child: ListTile(
        title: Text(recognition.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(recognition.description),
            const SizedBox(height: 4),
            Text(
              "Date: ${recognition.date.toLocal().toString().split(' ')[0]}",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Employee Recognitions")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _recognitions.isEmpty
          ? const Center(child: Text("No recognitions found."))
          : ListView.builder(
        itemCount: _recognitions.length,
        itemBuilder: (context, index) =>
            _buildRecognitionCard(_recognitions[index]),
      ),
    );
  }
}
