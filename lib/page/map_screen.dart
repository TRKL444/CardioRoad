import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cardioroad/shared/themes/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Posição inicial da câmara focada em Porto Velho, RO
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(-8.7619, -63.9039),
    zoom: 13.0,
  );

  // Conjunto de marcadores que serão exibidos no mapa
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _addMarkers();
  }

  // Função para adicionar os marcadores dos postos de saúde
  void _addMarkers() {
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('upa_leste'),
          position: const LatLng(-8.7758, -63.8344), // Coordenadas da UPA Leste
          infoWindow: InfoWindow(
            title: 'UPA Zona Leste',
            snippet: 'Atendimento de Urgência e Emergência',
            onTap: () => _launchMapsUrl(-8.7758, -63.8344),
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        ),
      );
      _markers.add(
        Marker(
          markerId: const MarkerId('ana_adelaide'),
          position: const LatLng(-8.7562, -63.8994), // Coordenadas da Policlínica Ana Adelaide
          infoWindow: InfoWindow(
            title: 'Policlínica Ana Adelaide',
            snippet: 'Atendimento Médico',
            onTap: () => _launchMapsUrl(-8.7562, -63.8994),
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
      _markers.add(
        Marker(
          markerId: const MarkerId('areal_floresta'),
          position: const LatLng(-8.7845, -63.8935), // Coordenadas do CS Areal da Floresta
          infoWindow: InfoWindow(
            title: 'Centro de Saúde Areal da Floresta',
            snippet: 'Atendimento Básico de Saúde',
            onTap: () => _launchMapsUrl(-8.7845, -63.8935),
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );
    });
  }

  // Função para abrir a localização no Google Maps
  Future<void> _launchMapsUrl(double lat, double lng) async {
    final Uri url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    if (!await launchUrl(url)) {
      // Exibe uma mensagem de erro se não conseguir abrir o link
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível abrir o mapa.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Postos de Saúde Próximos'),
        backgroundColor: AppColors.darkBackground,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: GoogleMap(
        initialCameraPosition: _initialCameraPosition,
        markers: _markers,
        mapType: MapType.normal,
        myLocationButtonEnabled: true,
        myLocationEnabled: true, // Pede permissão e mostra a localização do usuário
      ),
    );
  }
}

