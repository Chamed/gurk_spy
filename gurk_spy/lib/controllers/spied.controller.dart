import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gurk_spy/models/spied.model.dart';

class SpiedController {
  final SpiedModel _model = SpiedModel();
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  Timer? _locationTimer;

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
    _locationTimer?.cancel();
  }

  Future<void> startLocationUpdates(String spiedId) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Serviço de localização está desativado.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Permissão de localização negada.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Permissão de localização permanentemente negada.');
    }

    _locationTimer?.cancel();
    _locationTimer = Timer.periodic(const Duration(minutes: 2), (timer) async {
      final position = await Geolocator.getCurrentPosition();

      await _database.child('locations/$spiedId').set({
        'latitude': position.latitude,
        'longitude': position.longitude,
        'timestamp': DateTime.now().toIso8601String(),
      });

      print('Localização enviada: ${DateTime.now().toIso8601String()}');
    });
  }
}