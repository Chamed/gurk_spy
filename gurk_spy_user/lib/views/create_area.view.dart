import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:gurk_spy_user/controllers/create_area_controller.dart';

class CreateAreaView extends StatefulWidget {
  const CreateAreaView({super.key});

  @override
  State<CreateAreaView> createState() => _CreateAreaViewState();
}

class _CreateAreaViewState extends State<CreateAreaView> {
  late final CreateAreaController controller;
  final Completer<GoogleMapController> _mapController = Completer();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = CreateAreaController();
    controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criar Área Delimitadora')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar local...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () async {
                    try {
                      await controller.searchLocation(_searchController.text);
                      final ctrl = await _mapController.future;
                      ctrl.animateCamera(
                        CameraUpdate.newLatLngZoom(controller.mapPosition, 15),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Local não encontrado')),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: controller.mapPosition,
                zoom: 12,
              ),
              onMapCreated: (c) => _mapController.complete(c),
              onTap: controller.handleMapTap,
              circles: controller.circles,
              polygons: controller.polygons,
              markers: {
                Marker(
                  markerId: const MarkerId('selected'),
                  position: controller.mapPosition,
                ),
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton.icon(
              onPressed: () {
                print('Área registrada: ${controller.tappedPoints}');
              },
              icon: const Icon(Icons.check_circle_outline, color: Colors.white),
              label: const Text(
                'Registrar',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF673AB7),
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(
                  double.infinity,
                  56,
                ), // botão mais largo e alto
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
