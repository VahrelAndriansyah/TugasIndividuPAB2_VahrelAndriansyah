import 'package:firebase_database/firebase_database.dart';
import '../models/course.dart';
import '../models/note.dart';

class FirebaseService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  Future<void> createCourse(Course course) async {
    final ref = _db.child('courses').push();
    await ref.set(course.toJson());
  }

  Future<List<Course>> fetchCourses() async {
    final snapshot = await _db.child('courses').get();
    if (!snapshot.exists) return [];
    final data = snapshot.value as Map<dynamic, dynamic>;
    return data.entries.map((entry) {
      final id = entry.key as String;
      final value = Map<String, dynamic>.from(entry.value as Map);
      return Course.fromJson(id, value);
    }).toList();
  }

  Future<void> createNote(Note note) async {
    final ref = _db.child('notes').push();
    await ref.set(note.toJson());
  }

  Future<List<Note>> fetchNotes() async {
    final snapshot = await _db.child('notes').orderByChild('timestamp').get();
    if (!snapshot.exists) return [];
    final data = snapshot.value as Map<dynamic, dynamic>;
    return data.entries.map((entry) {
      final id = entry.key as String;
      final value = Map<String, dynamic>.from(entry.value as Map);
      return Note.fromJson(id, value);
    }).toList();
  }
}
