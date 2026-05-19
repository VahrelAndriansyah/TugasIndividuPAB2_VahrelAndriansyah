class Course {
  final String id;
  final String name;
  final String lecturer;

  Course({required this.id, required this.name, required this.lecturer});

  factory Course.fromJson(String id, Map<String, dynamic> json) {
    return Course(
      id: id,
      name: json['name'] as String? ?? '',
      lecturer: json['lecturer'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'lecturer': lecturer};
  }
}
