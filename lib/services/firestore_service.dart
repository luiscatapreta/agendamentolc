import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/appointment.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String collectionName = 'agendamentos';

  Stream<List<Appointment>> streamUserAppointments(String userId) {
    return _db
        .collection(collectionName)
        .where('userId', isEqualTo: userId)
        .orderBy('startAt')
        .snapshots()
        .map((snap) => snap.docs.map((d) => Appointment.fromFirestore(d)).toList());
  }

  Stream<List<Appointment>> streamAllAppointments() {
    return _db
        .collection(collectionName)
        .orderBy('startAt')
        .snapshots()
        .map((snap) => snap.docs.map((d) => Appointment.fromFirestore(d)).toList());
  }

  Future<void> addAppointment(Appointment a) async {
    await _db.collection(collectionName).add(a.toMap());
  }

  Future<void> updateAppointment(Appointment a) async {
    if (a.id == null) throw Exception('Appointment ID is null');
    await _db.collection(collectionName).doc(a.id).update(a.toMap());
  }

  Future<void> deleteAppointment(String id) async {
    await _db.collection(collectionName).doc(id).delete();
  }
}
