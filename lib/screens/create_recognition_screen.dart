import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/recognition_model.dart';
import '../services/firebase_service.dart';

class CreateRecognitionScreen extends StatefulWidget {
  final String employeeId;

  const CreateRecognitionScreen({super.key, required this.employeeId});

  @override
  State<CreateRecognitionScreen> createState() => _CreateRecognitionScreenState();
}

class _CreateRecognitionScreenState extends State<CreateRecognitionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _firebaseService = FirebaseService();

  bool _isSaving = false;

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);

      final recognition = Recognition(
        id: const Uuid().v4(),
        employeeId: widget.employeeId,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        date: DateTime.now(),
      );

      await _firebaseService.createRecognition(recognition);

      setState(() => _isSaving = false);
      Navigator.pop(context); // Go back after saving
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Recognition")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isSaving
            ? const Center(child: CircularProgressIndicator())
            : Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Title"),
                validator: (value) =>
                value == null || value.isEmpty ? "Enter title" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
                maxLines: 3,
                validator: (value) =>
                value == null || value.isEmpty ? "Enter description" : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                child: const Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
