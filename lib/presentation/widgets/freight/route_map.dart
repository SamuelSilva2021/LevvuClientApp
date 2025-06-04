import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:levvu_client/core/config/maps_config.dart';

class RouteMap extends StatefulWidget {
  final String originAddress;
  final String destinationAddress;

  const RouteMap({
    super.key,
    required this.originAddress,
    required this.destinationAddress,
  });

  @override
  State<RouteMap> createState() => _RouteMapState();
}

class _RouteMapState extends State<RouteMap> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  bool _isLoading = true;
  String? _error;
  LatLng? _initialPosition;
  List<LatLng> _routePoints = [];
  String _distance = '';
  String _duration = '';
  bool _showInfoCard = true;
  bool _isMapReady = false;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _initializeMap() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Converte endereços em coordenadas
      final originLocation = await locationFromAddress(widget.originAddress);
      final destinationLocation =
          await locationFromAddress(widget.destinationAddress);

      final origin = originLocation.first;
      final destination = destinationLocation.first;

      // Define a posição inicial como a origem
      _initialPosition = LatLng(origin.latitude, origin.longitude);

      // Cria marcadores para origem e destino
      _markers = {
        Marker(
          markerId: const MarkerId('origin'),
          position: LatLng(origin.latitude, origin.longitude),
          infoWindow: const InfoWindow(title: 'Origem'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
        Marker(
          markerId: const MarkerId('destination'),
          position: LatLng(destination.latitude, destination.longitude),
          infoWindow: const InfoWindow(title: 'Destino'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      };

      // Obtém a rota usando a API do Google Directions
      final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=${MapsConfig.apiKey}',
      ));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final route = data['routes'][0]['legs'][0];
          _distance = route['distance']['text'];
          _duration = route['duration']['text'];

          _routePoints =
              _decodePolyline(data['routes'][0]['overview_polyline']['points']);
          _polylines = {
            Polyline(
              polylineId: const PolylineId('route'),
              points: _routePoints,
              color: Colors.blue,
              width: 5,
            ),
          };
        } else {
          throw Exception('Não foi possível obter a rota: ${data['status']}');
        }
      } else {
        throw Exception('Erro ao obter a rota: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }

  LatLngBounds _getBounds(List<LatLng> points) {
    double? minLat, maxLat, minLng, maxLng;

    for (var point in points) {
      if (minLat == null || point.latitude < minLat) minLat = point.latitude;
      if (maxLat == null || point.latitude > maxLat) maxLat = point.latitude;
      if (minLng == null || point.longitude < minLng) minLng = point.longitude;
      if (maxLng == null || point.longitude > maxLng) maxLng = point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat!, minLng!),
      northeast: LatLng(maxLat!, maxLng!),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Erro ao carregar o mapa: $_error',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _initializeMap,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _initialPosition ?? const LatLng(-23.550520, -46.633308),
            zoom: 14,
          ),
          onMapCreated: (controller) {
            _mapController = controller;
            if (_routePoints.isNotEmpty && !_isMapReady) {
              _isMapReady = true;
              controller.animateCamera(
                CameraUpdate.newLatLngBounds(
                  _getBounds(_routePoints),
                  50.0,
                ),
              );
            }
          },
          markers: _markers,
          polylines: _polylines,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          zoomControlsEnabled: true,
          mapToolbarEnabled: true,
          mapType: MapType.normal,
          compassEnabled: true,
          zoomGesturesEnabled: true,
          scrollGesturesEnabled: true,
          tiltGesturesEnabled: true,
          rotateGesturesEnabled: true,
        ),
        if (_showInfoCard)
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Card(
              elevation: 4,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Icon(Icons.route, color: Colors.blue),
                            const SizedBox(height: 4),
                            Text(
                              _distance,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text('Distância'),
                          ],
                        ),
                        Column(
                          children: [
                            const Icon(Icons.timer, color: Colors.blue),
                            const SizedBox(height: 4),
                            Text(
                              _duration,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text('Tempo estimado'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () {
                        setState(() {
                          _showInfoCard = false;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (!_showInfoCard)
          Positioned(
            bottom: 16,
            left: 16,
            child: FloatingActionButton(
              mini: true,
              onPressed: () {
                setState(() {
                  _showInfoCard = true;
                });
              },
              child: const Icon(Icons.info_outline),
            ),
          ),
      ],
    );
  }
}
