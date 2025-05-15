import 'package:final_year_project/screens/create_task_screen.dart';
import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/recognition_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmployeeRecognitionScreen extends StatefulWidget {
  const EmployeeRecognitionScreen({super.key});

  @override
  State<EmployeeRecognitionScreen> createState() => _EmployeeRecognitionScreenState();
}

class _EmployeeRecognitionScreenState extends State<EmployeeRecognitionScreen> {
  final _firebaseService = FirebaseService();
  List<Recognition> _recognitions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecognitions();
  }

  Future<void> _loadRecognitions() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final recs = await _firebaseService.getRecognitionsForEmployee(user.uid);
    setState(() {
      _recognitions = recs;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Recognitions")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _recognitions.isEmpty
          ? const Center(child: Text("No recognitions found."))
          : ListView.builder(
        itemCount: _recognitions.length,
        itemBuilder: (ctx, index) {
          final rec = _recognitions[index];
          return Card(
            child: ListTile(
              title: Text(rec.title),
              subtitle: Text(rec.description),
              trailing: Text("${rec.date.toLocal().toShortString()}"),
            ),
          );
        },
      ),
    );
  }
}
