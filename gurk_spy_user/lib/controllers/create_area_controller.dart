import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class CreateAreaController extends ChangeNotifier {
  List<LatLng> tappedPoints = [];
  Set<Circle> circles = {};
  Set<Polygon> polygons = {};
  LatLng mapPosition = const LatLng(-23.55052, -46.633308);
  String areaType = '';

  // Getter corrigido
  List<LatLng> get pontosArea => tappedPoints;

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
      areaType = 'circle';
      circles = {
        Circle(
          circleId: const CircleId('area_circulo'),
          center: position,
          radius: 100,
          fillColor: const Color.fromARGB(255, 2, 255, 15).withOpacity(0.3),
          strokeColor: const Color.fromARGB(255, 255, 0, 0),
          strokeWidth: 2,
        )
      };
      polygons.clear();
    } else if (tappedPoints.length == 3) {
      areaType = 'polygon';
      polygons = {
        Polygon(
          polygonId: const PolygonId('triangulo'),
          points: tappedPoints.sublist(0, 3),
          fillColor: const Color.fromARGB(255, 0, 255, 64).withOpacity(0.4),
          strokeColor: Colors.red,
          strokeWidth: 2,
        )
      };
      circles.clear();
      tappedPoints.clear();
    }

    notifyListeners();
  }
}
