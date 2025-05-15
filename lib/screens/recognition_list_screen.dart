import 'package:final_year_project/screens/create_task_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/recognition_model.dart';
import '../services/firebase_service.dart';

class RecognitionListScreen extends StatefulWidget {
  const RecognitionListScreen({super.key});

  @override
  State<RecognitionListScreen> createState() => _RecognitionListScreenState();
}

class _RecognitionListScreenState extends State<RecognitionListScreen> {
  final _firebaseService = FirebaseService();
  List<Recognition> _recognitions = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadRecognitions();
  }

  Future<void> _loadRecognitions() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final recognitions = await _firebaseService.getRecognitionsForEmployee(userId);
    setState(() {
      _recognitions = recognitions;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Recognitions")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _recognitions.isEmpty
          ? const Center(child: Text("No recognitions found."))
          : ListView.builder(
        itemCount: _recognitions.length,
          itemBuilder: (context, index) {
            final rec = _recognitions[index];
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const Icon(Icons.emoji_events, color: Colors.amber),
                title: Text(
                  rec.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Text(rec.description),
                trailing: Text(
                  "${rec.date.day}/${rec.date.month}/${rec.date.year}",
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            );
          }

      ),
    );
  }
}
