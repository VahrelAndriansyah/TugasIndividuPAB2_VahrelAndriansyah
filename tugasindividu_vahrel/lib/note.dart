class Note {
  final String id;
  final String courseId;
  final String courseName;
  final String title;
  final String content;
  final int timestamp;

  Note({
    required this.id,
    required this.courseId,
    required this.courseName,
    required this.title,
    required this.content,
    required this.timestamp,
  });

  factory Note.fromJson(String id, Map<String, dynamic> json) {
    return Note(
      id: id,
      courseId: json['courseId'] as String? ?? '',
      courseName: json['courseName'] as String? ?? '',
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      timestamp: json['timestamp'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'courseName': courseName,
      'title': title,
      'content': content,
      'timestamp': timestamp,
    };
  }
}
