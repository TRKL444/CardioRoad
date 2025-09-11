import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cardioroad/shared/themes/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  Position? _currentPosition;
  bool _isLoading = true;

  // Marcadores de exemplo para postos de saúde
  final Set<Marker> _markers = {
    const Marker(
      markerId: MarkerId('upa_leste'),
      position: LatLng(-8.7497, -63.8488), // Coordenadas da UPA Leste
      infoWindow: InfoWindow(
        title: 'UPA Leste',
        snippet: 'Pronto Atendimento 24h',
      ),
    ),
    const Marker(
      markerId: MarkerId('policlinica_ana_adelaide'),
      position: LatLng(
        -8.7625,
        -63.8821,
      ), // Coordenadas da Policlínica Ana Adelaide
      infoWindow: InfoWindow(
        title: 'Policlínica Ana Adelaide',
        snippet: 'Atendimento Médico',
      ),
    ),
  };

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // O serviço de localização está desativado.
      _showErrorDialog('Serviço de localização desativado.');
      setState(() => _isLoading = false);
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showErrorDialog('Permissão de localização negada.');
        setState(() => _isLoading = false);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showErrorDialog(
        'A permissão de localização foi negada permanentemente.',
      );
      setState(() => _isLoading = false);
      return;
    }

    // Se as permissões foram concedidas, pega a posição.
    try {
      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = position;
        _isLoading = false;
      });
    } catch (e) {
      _showErrorDialog('Não foi possível obter a localização.');
      setState(() => _isLoading = false);
    }
  }

  void _showErrorDialog(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erro de Localização'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  // Função para abrir o Google Maps com a rota
  Future<void> _openMaps(double lat, double lng) async {
    final uri = Uri.parse(
      "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng",
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Postos de Saúde Próximos'),
        backgroundColor: AppColors.darkBackground,
        iconTheme: const IconThemeData(color: AppColors.white),
        titleTextStyle: const TextStyle(
          color: AppColors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _currentPosition == null
          ? const Center(
              child: Text(
                'Não foi possível obter sua localização.\nVerifique as permissões do aplicativo.',
                textAlign: TextAlign.center,
              ),
            )
          : GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  _currentPosition!.latitude,
                  _currentPosition!.longitude,
                ),
                zoom: 14.0,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: _markers.map((marker) {
                return marker.copyWith(
                  onTapParam: () {
                    // Ao tocar no marcador, abre o Google Maps
                    _openMaps(
                      marker.position.latitude,
                      marker.position.longitude,
                    );
                  },
                );
              }).toSet(),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
    );
  }
}
