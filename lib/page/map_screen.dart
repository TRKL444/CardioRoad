import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cardioroad/shared/themes/app_colors.dart';
import 'package:geolocator/geolocator.dart'; // Para obter a localização do utilizador
import 'package:http/http.dart' as http;    // Para fazer a chamada à API
import 'dart:convert';                      // Para converter JSON
import 'dart:math';                         // Para calcular a distância

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Posição inicial da câmara (será atualizada para a do utilizador)
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(-8.7619, -63.9039), // Porto Velho como fallback
    zoom: 14.0,
  );

  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  bool _isLoading = true;
  String _loadingMessage = "A obter a sua localização...";

  @override
  void initState() {
    super.initState();
    _findHealthCentersFromPublicApi();
  }

  // Função principal que orquestra a busca
  Future<void> _findHealthCentersFromPublicApi() async {
    try {
      // 1. Obter a localização atual do utilizador
      Position position = await _determinePosition();
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)),
      );

      // 2. Descobrir a UF a partir das coordenadas
      setState(() => _loadingMessage = "A identificar o seu estado...");
      final String? uf = await _getUfFromCoordinates(position.latitude, position.longitude);

      if (uf == null) {
        throw Exception("Não foi possível determinar o estado (UF).");
      }

      // 3. Chamar a API do Ministério da Saúde
      setState(() => _loadingMessage = "A procurar postos de saúde em ${uf.toUpperCase()}...");
      final url = Uri.parse('https://apidadosabertos.saude.gov.br/cnes/estabelecimentos?uf=${uf.toLowerCase()}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> allHealthCenters = json.decode(response.body);

        // 4. Calcular distâncias, ordenar e criar os marcadores
        final nearestCenters = _processHealthCenters(allHealthCenters, position.latitude, position.longitude);

        setState(() {
          _markers.clear();
          for (var center in nearestCenters) {
            _markers.add(
              Marker(
                markerId: MarkerId(center['coCnes']),
                position: LatLng(double.parse(center['vlrLatitude']), double.parse(center['vlrLongitude'])),
                infoWindow: InfoWindow(
                  title: center['noFantasia'],
                  snippet: center['noLogradouro'],
                ),
              ),
            );
          }
        });
      } else {
        throw Exception('Falha ao carregar dados dos postos de saúde.');
      }
    } catch (e) {
      print("Erro ao procurar postos de saúde: $e");
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: ${e.toString()}')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Função para chamar a API Nominatim e obter a UF
  Future<String?> _getUfFromCoordinates(double lat, double lon) async {
    try {
      final url = Uri.parse('https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon');
      // A API Nominatim exige um User-Agent no cabeçalho
      final response = await http.get(url, headers: {'User-Agent': 'CardioRoadApp/1.0'});
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final isoCode = data['address']['ISO3166-2-lvl4'];
        if (isoCode != null && isoCode.contains('-')) {
          return isoCode.split('-')[1]; // Retorna apenas a sigla da UF, ex: "RO"
        }
      }
      return null;
    } catch (e) {
      print("Erro na geocodificação reversa: $e");
      return null;
    }
  }
  
  // Função para processar os dados e encontrar os mais próximos
  List<dynamic> _processHealthCenters(List<dynamic> centers, double userLat, double userLon) {
    // Filtra apenas os que têm coordenadas válidas
    final centersWithLocation = centers.where((p) {
      final lat = p['vlrLatitude'];
      final lon = p['vlrLongitude'];
      return lat != null && lon != null && lat.isNotEmpty && lon.isNotEmpty;
    }).toList();

    // Adiciona a distância a cada posto
    for (var center in centersWithLocation) {
      final centerLat = double.parse(center['vlrLatitude']);
      final centerLon = double.parse(center['vlrLongitude']);
      center['distancia'] = _calculateDistance(userLat, userLon, centerLat, centerLon);
    }

    // Ordena pela distância
    centersWithLocation.sort((a, b) => a['distancia'].compareTo(b['distancia']));
    
    // Retorna os 10 mais próximos
    return centersWithLocation.take(10).toList();
  }
  
  // Função para calcular a distância em KM
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 + 
          c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Postos de Saúde Próximos'),
        backgroundColor: AppColors.darkBackground,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            markers: _markers,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            onMapCreated: (controller) => _mapController = controller,
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
                    Text(
                      _loadingMessage,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Função auxiliar para pedir e obter a localização
  Future<Position> _determinePosition() async {
    // (O código desta função continua o mesmo da versão anterior)
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Os serviços de localização estão desativados.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('As permissões de localização foram negadas.');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'As permissões de localização foram negadas permanentemente.');
    }
    return await Geolocator.getCurrentPosition();
  }
}

