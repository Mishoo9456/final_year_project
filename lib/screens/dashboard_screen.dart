import 'package:final_year_project/screens/task_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/create_task_screen.dart';
import '../screens/login_screen.dart';
import '../screens/employee_recognition_screen.dart';
//import '../screens/employee_task_list_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isDarkMode = false;
  int _selectedIndex = 0;

  final List<Widget> _screens = [];

  final List<Color> _navBarColors = [
    Colors.deepPurple,
    Colors.teal,
    Colors.orange,
  ];

  @override
  void initState() {
    super.initState();
    _screens.addAll([
      const EmployeeTaskListScreen(),
      const EmployeeRecognitionScreen(),
      //CreateTaskScreen(onTaskCreated: _showTaskCreatedSnackbar),
    ]);
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
    final isDark = _isDarkMode;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDark
          ? ThemeData.dark(useMaterial3: true)
          : ThemeData.light(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
          elevation: 6,
          backgroundColor: _navBarColors[_selectedIndex],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          title: const Padding(
            padding: EdgeInsets.only(left: 4.0),
            child: Text(
              "Employee Dashboard",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
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
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          transitionBuilder: (child, animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: _screens[_selectedIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          items: [
            BottomNavigationBarItem(
              backgroundColor: _navBarColors[0],
              icon: const Icon(Icons.assignment_turned_in_outlined),
              activeIcon: const Icon(Icons.assignment_turned_in),
              label: 'My Tasks',
            ),
            BottomNavigationBarItem(
              backgroundColor: _navBarColors[1],
              icon: const Icon(Icons.emoji_events_outlined),
              activeIcon: const Icon(Icons.emoji_events),
              label: 'Recognitions',
            ),
            // BottomNavigationBarItem(
            //   backgroundColor: _navBarColors[2],
            //   icon: const Icon(Icons.add_task_outlined),
            //   activeIcon: const Icon(Icons.add_task),
            //   label: 'Create Task',
            // ),
          ],
        ),
      ),
    );
  }
}
