import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'admin_task_list.dart';
import 'create_task_screen.dart';
import 'create_recognition_screen.dart';
import 'employee_recognition_list_screen.dart';
import 'task_list_screen.dart';
import 'login_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;
  bool _isDarkMode = false;

  late final List<Widget> _screens;
  final List<Color> _navBarColors = [
    Colors.blueGrey,
    Colors.deepOrange,
    Colors.green,
    Colors.purple,
  ];

  @override
  void initState() {
    super.initState();
    _screens = [
      TaskListScreen(),
      CreateTaskScreen(
        onTaskCreated: _showTaskCreatedSnackbar,
      ),
      CreateRecognitionScreen(employeeId: ''),
      EmployeeRecognitionListScreen(employeeId: '',),
    ];
  }

  void _showTaskCreatedSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Task created successfully!"),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? ThemeData.dark(useMaterial3: true) : ThemeData.light(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: _navBarColors[_selectedIndex],
          title: const Text("Admin Dashboard"),
          actions: [
            IconButton(
              icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
              tooltip: "Toggle Theme",
              onPressed: _toggleTheme,
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: "Logout",
              onPressed: _logout,
            ),
          ],
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _screens[_selectedIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.task),
              label: 'All Tasks',
              backgroundColor: Colors.blueGrey,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_task),
              label: 'Create Task',
              backgroundColor: Colors.deepOrange,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events),
              label: 'Give Award',
              backgroundColor: Colors.green,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: 'Awards List',
              backgroundColor: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }
}
