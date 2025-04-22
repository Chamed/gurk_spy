import 'package:google_maps_flutter/google_maps_flutter.dart';

class Monitored {
  final String nome;
  final int idade;
  final String endereco;
  final String codigoRastreamento;
  final List<LatLng> areaDelimitada;

  Monitored({
    required this.nome,
    required this.idade,
    required this.endereco,
    required this.codigoRastreamento,
    required this.areaDelimitada,
  });

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'idade': idade,
      'endereco': endereco,
      'codigoRastreamento': codigoRastreamento,
      'areaDelimitada': areaDelimitada
          .map((p) => {'latitude': p.latitude, 'longitude': p.longitude})
          .toList(),
    };
  }
}
