import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/monitored_model.dart';

class MonitoredController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> cadastrarPaciente(Monitored paciente) async {
  final user = _auth.currentUser;

  await _firestore.collection('spied').doc(paciente.codigoRastreamento).set({
    ...paciente.toMap(),
    'createdAt': FieldValue.serverTimestamp(),
    'createdBy': user?.uid ?? 'desconhecido',
  });
}

}
