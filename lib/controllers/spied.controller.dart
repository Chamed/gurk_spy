import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gurk_spy/models/spied.model.dart';

class SpiedController {
  final SpiedModel _model = SpiedModel();

  Future<void> initDatabase() async {
    await _model.initDatabase();
  }

  Future<String?> getSpied() async {
    return await _model.getSpied();
  }

  Future<void> fetchSpied(String code) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('spied')
        .doc(code)
        .get();

    if (snapshot.exists) {
      final name = snapshot.data()?['name'] as String?;
      if (name != null) {
        await _model.saveSpied(name, code);
      }
    } else {
      throw Exception('Usuário não encontrado');
    }
  }

  Future<void> desconect() async {
    await _model.deleteSpied();
  }
}