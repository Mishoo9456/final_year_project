import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:final_year_project/screens/task_list_screen.dart';

import 'recognition_list_screen.dart';
import 'create_task_screen.dart';
import 'create_recognition_screen.dart';
import 'login_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  bool _isDarkMode = false;
  int _selectedIndex = 0;

  final List<Color> _navBarColors = [
    Colors.indigo,
    Colors.green,
    Colors.orange,
    Colors.blueGrey,
  ];

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      //const TaskListScreen(),
      const RecognitionListScreen(),
      CreateTaskScreen(
        onTaskCreated: _showTaskCreatedSnackbar,
      ),
      const CreateRecognitionScreen(employeeId: ""), // Update employeeId as needed
    ];
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showTaskCreatedSnackbar() {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.green,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 2),
      content: Row(
        children: const [
          Icon(Icons.check_circle, color: Colors.white),
          SizedBox(width: 10),
          Text("Task Created Successfully!"),
        ],
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode
          ? ThemeData.dark(useMaterial3: true)
          : ThemeData.light(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: _navBarColors[_selectedIndex],
          title: const Text("Admin Dashboard"),
          actions: [
            IconButton(
              icon: Icon(_isDarkMode ? Icons.dark_mode : Icons.light_mode),
              onPressed: _toggleTheme,
              tooltip: "Toggle Theme",
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _logout,
              tooltip: "Logout",
            ),
          ],
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _screens[_selectedIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.shifting,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              backgroundColor: _navBarColors[0],
              icon: const Icon(Icons.task),
              label: "All Tasks",
            ),
            BottomNavigationBarItem(
              backgroundColor: _navBarColors[1],
              icon: const Icon(Icons.emoji_events),
              label: "Recognitions",
            ),
            BottomNavigationBarItem(
              backgroundColor: _navBarColors[2],
              icon: const Icon(Icons.add_task),
              label: "Create Task",
            ),
            BottomNavigationBarItem(
              backgroundColor: _navBarColors[3],
              icon: const Icon(Icons.star),
              label: "Create Recognition",
            ),
          ],
        ),
      ),
    );
  }
}
