import 'package:flutter/material.dart';
import '../models/course.dart';
import '../services/firebase_service.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  final FirebaseService _service = FirebaseService();
  final _nameController = TextEditingController();
  final _lecturerController = TextEditingController();
  List<Course> _courses = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    final courses = await _service.fetchCourses();
    setState(() {
      _courses = courses;
      _loading = false;
    });
  }

  Future<void> _addCourse() async {
    if (_nameController.text.isEmpty || _lecturerController.text.isEmpty)
      return;
    final course = Course(
      id: '',
      name: _nameController.text.trim(),
      lecturer: _lecturerController.text.trim(),
    );
    await _service.createCourse(course);
    _nameController.clear();
    _lecturerController.clear();
    await _loadCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Nama Mata Kuliah'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _lecturerController,
            decoration: const InputDecoration(labelText: 'Nama Dosen'),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _addCourse,
            child: const Text('Tambah Mata Kuliah'),
          ),
          const SizedBox(height: 20),
          if (_loading)
            const Center(child: CircularProgressIndicator())
          else
            Expanded(
              child: ListView.builder(
                itemCount: _courses.length,
                itemBuilder: (context, index) {
                  final course = _courses[index];
                  return ListTile(
                    title: Text(course.name),
                    subtitle: Text(course.lecturer),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
