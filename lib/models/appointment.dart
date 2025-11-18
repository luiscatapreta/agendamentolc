import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  String? id;
  String userId;
  String title;
  String description;
  DateTime startAt;
  double value;

  Appointment({
    this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.startAt,
    required this.value,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'startAt': Timestamp.fromDate(startAt),
      'value': value,
    };
  }

  factory Appointment.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Appointment(
      id: doc.id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      startAt: (data['startAt'] as Timestamp).toDate(),
      value: (data['value'] ?? 0).toDouble(),
    );
  }
}
