import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class CreateAreaController extends ChangeNotifier {
  List<LatLng> tappedPoints = [];
  List<LatLng> areaPoints = [];
  Set<Circle> circles = {};
  Set<Polygon> polygons = {};
  LatLng mapPosition = const LatLng(-23.55052, -46.633308);
  String areaType = '';


  List<LatLng> get pontosArea => areaPoints;

  Future<void> searchLocation(String query) async {
    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        final location = locations.first;
        mapPosition = LatLng(location.latitude, location.longitude);
        notifyListeners();
      }
    } catch (e) {
      throw Exception("Local não encontrado.");
    }
  }

  void handleMapTap(LatLng position) {
  tappedPoints.add(position);
  mapPosition = position;

  if (tappedPoints.length == 1) {
    // Primeiro clique — centro do círculo
    areaType = 'circle';
    circles.clear();
    polygons.clear();

    areaPoints = [position];
  } else if (tappedPoints.length == 2) {
    // Segundo clique — borda do círculo
    final LatLng center = tappedPoints[0];
    final LatLng edge = tappedPoints[1];

    double radius = _calculateDistance(center, edge);

    circles = {
      Circle(
        circleId: const CircleId('area_circulo'),
        center: center,
        radius: radius,
        fillColor: const Color.fromARGB(255, 2, 255, 15).withOpacity(0.3),
        strokeColor: const Color.fromARGB(255, 255, 0, 0),
        strokeWidth: 2,
      )
    };

    areaPoints = [center, edge]; // salva o centro e ponto de borda
    polygons.clear();
  } else if (tappedPoints.length == 3) {
    // Terceiro clique — inicia triângulo
    areaType = 'polygon';
    final trianglePoints = tappedPoints.sublist(0, 3);
    polygons = {
      Polygon(
        polygonId: const PolygonId('triangulo'),
        points: trianglePoints,
        fillColor: const Color.fromARGB(255, 0, 255, 64).withOpacity(0.4),
        strokeColor: Colors.red,
        strokeWidth: 2,
      )
    };
    circles.clear();
    areaPoints = trianglePoints;
    tappedPoints.clear(); 
  }

  notifyListeners();
}

// Método auxiliar para calcular distância em metros entre dois pontos geográficos
double _calculateDistance(LatLng p1, LatLng p2) {
  const double R = 6371000; 
  double dLat = _degreesToRadians(p2.latitude - p1.latitude);
  double dLng = _degreesToRadians(p2.longitude - p1.longitude);

  double a = 
    (sin(dLat / 2) * sin(dLat / 2)) +
    cos(_degreesToRadians(p1.latitude)) *
    cos(_degreesToRadians(p2.latitude)) *
    (sin(dLng / 2) * sin(dLng / 2));

  double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return R * c;
}

double _degreesToRadians(double degrees) {
  return degrees * (pi / 180);
}

}

