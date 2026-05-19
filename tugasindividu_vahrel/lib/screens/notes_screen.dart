import 'package:flutter/material.dart';
import '../models/course.dart';
import '../models/note.dart';
import '../services/firebase_service.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final FirebaseService _service = FirebaseService();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  List<Course> _courses = [];
  List<Note> _notes = [];
  Course? _selectedCourse;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final courses = await _service.fetchCourses();
    final notes = await _service.fetchNotes();
    setState(() {
      _courses = courses;
      _notes = notes;
      _selectedCourse = courses.isNotEmpty ? courses.first : null;
      _loading = false;
    });
  }

  Future<void> _addNote() async {
    if (_selectedCourse == null ||
        _titleController.text.isEmpty ||
        _contentController.text.isEmpty)
      return;

    final note = Note(
      id: '',
      courseId: _selectedCourse!.id,
      courseName: _selectedCourse!.name,
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
    await _service.createNote(note);
    _titleController.clear();
    _contentController.clear();
    await _loadData();
  }

  String _formatTimestamp(int ts) {
    final date = DateTime.fromMillisecondsSinceEpoch(ts);
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                DropdownButtonFormField<Course>(
                  value: _selectedCourse,
                  items: _courses
                      .map(
                        (course) => DropdownMenuItem(
                          value: course,
                          child: Text(course.name),
                        ),
                      )
                      .toList(),
                  onChanged: (course) =>
                      setState(() => _selectedCourse = course),
                  decoration: const InputDecoration(
                    labelText: 'Pilih Mata Kuliah',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Judul Catatan'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _contentController,
                  decoration: const InputDecoration(labelText: 'Isi Catatan'),
                  minLines: 3,
                  maxLines: 5,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _addNote,
                  child: const Text('Tambah Catatan'),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: _notes.isEmpty
                      ? const Center(child: Text('Belum ada catatan'))
                      : ListView.builder(
                          itemCount: _notes.length,
                          itemBuilder: (context, index) {
                            final note = _notes[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              child: ListTile(
                                title: Text(note.title),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(note.courseName),
                                    const SizedBox(height: 4),
                                    Text(note.content),
                                    const SizedBox(height: 6),
                                    Text(
                                      _formatTimestamp(note.timestamp),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
