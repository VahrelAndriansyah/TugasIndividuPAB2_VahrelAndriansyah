import 'package:flutter/material.dart';
import 'courses_screen.dart';
import 'notes_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [CoursesScreen(), NotesScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catatan Kuliah')),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Mata Kuliah'),
          BottomNavigationBarItem(icon: Icon(Icons.note), label: 'Catatan'),
        ],
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
