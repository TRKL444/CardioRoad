import 'package:flutter/material.dart';
import 'package:cardioroad/shared/themes/app_colors.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle; // Para ler ficheiros locais

// Importações dos pacotes do OpenStreetMap
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final List<Marker> _markers = [];
  bool _isLoading = true;
  String _loadingMessage = "A obter a sua localização...";
  LatLng _initialCenter = const LatLng(-8.7619, -63.9039); // Porto Velho como fallback

  @override
  void initState() {
    super.initState();
    _findHealthCentersFromLocalFile();
  }

  // Função principal que lê do ficheiro local
  Future<void> _findHealthCentersFromLocalFile() async {
    try {
      // 1. Obter a localização atual do utilizador
      setState(() => _loadingMessage = "A obter a sua localização...");
      Position position = await _determinePosition();
      final userLocation = LatLng(position.latitude, position.longitude);

      setState(() {
        _initialCenter = userLocation;
        _mapController.move(userLocation, 13.0);
        // Adiciona o marcador do utilizador
        _markers.add(
          Marker(
            point: userLocation,
            width: 80,
            height: 80,
            child: const Icon(Icons.person_pin_circle, color: Colors.blue, size: 45),
          ),
        );
        _loadingMessage = "A carregar postos de saúde...";
      });

      // 2. LER O FICHEIRO JSON LOCAL
      final String jsonString = await rootBundle.loadString('assets/postos_ro.json');
      
      // --- CORREÇÃO IMPORTANTE AQUI ---
      // Esta nova lógica verifica se o JSON é uma lista diretamente ou um objeto que contém a lista
      final dynamic decodedJson = json.decode(jsonString);
      List<dynamic> allHealthCenters;

      if (decodedJson is Map<String, dynamic> && decodedJson.containsKey('estabelecimentos')) {
        // Se for um objeto com a chave 'estabelecimentos' (como na API online)
        allHealthCenters = decodedJson['estabelecimentos'];
      } else if (decodedJson is List<dynamic>) {
        // Se for uma lista diretamente (como no nosso ficheiro de cache)
        allHealthCenters = decodedJson;
      } else {
        throw Exception("Formato do ficheiro JSON inválido.");
      }
      
      print("✅ Dados lidos do ficheiro local: ${allHealthCenters.length} estabelecimentos encontrados.");
        
      // 3. Processar os dados e encontrar os mais próximos
      final nearestCenters = _processHealthCenters(allHealthCenters, position.latitude, position.longitude);
      print("💡 ${nearestCenters.length} postos de saúde mais próximos filtrados.");
        
      final newMarkers = nearestCenters.map((center) {
        final nome = center['nome_do_estabelecimento'] ?? 'Nome não informado';
        
        return Marker(
          point: LatLng(center['lat_corrigida'], center['lon_corrigida']),
          width: 80,
          height: 80,
          child: Tooltip(
            message: nome,
            child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
          ),
        );
      }).toList();

      setState(() => _markers.addAll(newMarkers));
      
    } catch (e) {
      print("❌ Erro ao processar dados locais: $e");
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Ocorreu um erro ao carregar os dados locais: ${e.toString().replaceAll("Exception: ", "")}'),
          backgroundColor: Colors.red,
        ));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Função de processamento que lê os dados do JSON
  List<dynamic> _processHealthCenters(List<dynamic> centers, double userLat, double userLon) {
    List<Map<String, dynamic>> centersWithLocation = [];

    for (var center in centers) {
      final latString = center['latitude'];
      final lonString = center['longitude'];

      if (latString != null && lonString != null) {
        final latCorrigida = double.tryParse(latString.toString().replaceAll(',', '.'));
        final lonCorrigida = double.tryParse(lonString.toString().replaceAll(',', '.'));

        if (latCorrigida != null && lonCorrigida != null) {
          Map<String, dynamic> newCenter = Map.from(center);
          newCenter['lat_corrigida'] = latCorrigida;
          newCenter['lon_corrigida'] = lonCorrigida;
          newCenter['distancia'] = _calculateDistance(userLat, userLon, latCorrigida, lonCorrigida);
          centersWithLocation.add(newCenter);
        }
      }
    }
    
    centersWithLocation.sort((a, b) => a['distancia'].compareTo(b['distancia']));
    return centersWithLocation.take(10).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Postos de Saúde - RO'),
        backgroundColor: AppColors.darkBackground,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _initialCenter,
              initialZoom: 13.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.cardioroad',
              ),
              MarkerLayer(markers: _markers),
            ],
          ),
          if (_isLoading)
            Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(color: Colors.white),
                    const SizedBox(height: 16),
                    Text(_loadingMessage, style: const TextStyle(color: Colors.white, fontSize: 16)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
  
  // --- Funções Auxiliares (permanecem as mesmas) ---
  
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 + 
          c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }
  
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Os serviços de localização estão desativados. Por favor, ative o GPS.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('As permissões de localização foram negadas.');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('As permissões de localização foram negadas permanentemente.');
    }
    return await Geolocator.getCurrentPosition();
  }
}

