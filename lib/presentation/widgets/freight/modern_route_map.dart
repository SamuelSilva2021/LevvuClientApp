import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:levvu_client/core/config/maps_config.dart';
import 'dart:ui' as ui;
import 'package:geolocator/geolocator.dart';

class ModernRouteMap extends StatefulWidget {
  final String originAddress;
  final String destinationAddress;
  final Function(String distance, String duration) onRouteCalculated;

  const ModernRouteMap({
    super.key,
    required this.originAddress,
    required this.destinationAddress,
    required this.onRouteCalculated,
  });

  @override
  State<ModernRouteMap> createState() => _ModernRouteMapState();
}

class _ModernRouteMapState extends State<ModernRouteMap>
    with TickerProviderStateMixin {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  bool _isLoading = false;
  String? _error;
  LatLng? _currentPosition;
  List<LatLng> _routePoints = [];
  String _distance = '';
  String _duration = '';
  bool _showRouteDetails = true;
  bool _isMapReady = false;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  Timer? _styleUpdateTimer;

  // Coordenadas padrão (São Paulo)
  static const _defaultCenter = LatLng(-23.5505, -46.6333);

  // Estilo de mapa moderno (escuro)
  static const String _darkMapStyle = '''
  [
    {
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#212121"
        }
      ]
    },
    {
      "elementType": "labels.icon",
      "stylers": [
        {
          "visibility": "off"
        }
      ]
    },
    {
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#757575"
        }
      ]
    },
    {
      "elementType": "labels.text.stroke",
      "stylers": [
        {
          "color": "#212121"
        }
      ]
    },
    {
      "featureType": "administrative",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#757575"
        }
      ]
    },
    {
      "featureType": "administrative.country",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#9e9e9e"
        }
      ]
    },
    {
      "featureType": "administrative.land_parcel",
      "stylers": [
        {
          "visibility": "off"
        }
      ]
    },
    {
      "featureType": "administrative.locality",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#bdbdbd"
        }
      ]
    },
    {
      "featureType": "poi",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#757575"
        }
      ]
    },
    {
      "featureType": "poi.park",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#181818"
        }
      ]
    },
    {
      "featureType": "poi.park",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#616161"
        }
      ]
    },
    {
      "featureType": "poi.park",
      "elementType": "labels.text.stroke",
      "stylers": [
        {
          "color": "#1b1b1b"
        }
      ]
    },
    {
      "featureType": "road",
      "elementType": "geometry.fill",
      "stylers": [
        {
          "color": "#2c2c2c"
        }
      ]
    },
    {
      "featureType": "road",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#8a8a8a"
        }
      ]
    },
    {
      "featureType": "road.arterial",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#373737"
        }
      ]
    },
    {
      "featureType": "road.highway",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#3c3c3c"
        }
      ]
    },
    {
      "featureType": "road.highway.controlled_access",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#4e4e4e"
        }
      ]
    },
    {
      "featureType": "road.local",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#616161"
        }
      ]
    },
    {
      "featureType": "transit",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#757575"
        }
      ]
    },
    {
      "featureType": "water",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#000000"
        }
      ]
    },
    {
      "featureType": "water",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#3d3d3d"
        }
      ]
    }
  ]
  ''';

  // Estilo de mapa moderno (claro)
  static const String _lightMapStyle = '''
  [
    {
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#f5f5f5"
        }
      ]
    },
    {
      "elementType": "labels.icon",
      "stylers": [
        {
          "visibility": "off"
        }
      ]
    },
    {
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#616161"
        }
      ]
    },
    {
      "elementType": "labels.text.stroke",
      "stylers": [
        {
          "color": "#f5f5f5"
        }
      ]
    },
    {
      "featureType": "administrative",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#616161"
        }
      ]
    },
    {
      "featureType": "administrative.country",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#9e9e9e"
        }
      ]
    },
    {
      "featureType": "administrative.land_parcel",
      "stylers": [
        {
          "visibility": "off"
        }
      ]
    },
    {
      "featureType": "administrative.locality",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#616161"
        }
      ]
    },
    {
      "featureType": "poi",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#757575"
        }
      ]
    },
    {
      "featureType": "poi.park",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#e5e5e5"
        }
      ]
    },
    {
      "featureType": "poi.park",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#9e9e9e"
        }
      ]
    },
    {
      "featureType": "road",
      "elementType": "geometry.fill",
      "stylers": [
        {
          "color": "#ffffff"
        }
      ]
    },
    {
      "featureType": "road",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#616161"
        }
      ]
    },
    {
      "featureType": "road.arterial",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#ffffff"
        }
      ]
    },
    {
      "featureType": "road.highway",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#dadada"
        }
      ]
    },
    {
      "featureType": "road.highway.controlled_access",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#e6e6e6"
        }
      ]
    },
    {
      "featureType": "road.local",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#9e9e9e"
        }
      ]
    },
    {
      "featureType": "transit",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#757575"
        }
      ]
    },
    {
      "featureType": "water",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#c9c9c9"
        }
      ]
    },
    {
      "featureType": "water",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#9e9e9e"
        }
      ]
    }
  ]
  ''';

  bool _isNightTime() {
    final now = DateTime.now();
    final hour = now.hour;
    // Considera noite entre 18h e 6h
    return hour >= 18 || hour < 6;
  }

  String _getMapStyle() {
    return _isNightTime() ? _darkMapStyle : _lightMapStyle;
  }

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));
    _getCurrentLocation();

    // Inicia o timer para atualizar o estilo do mapa a cada minuto
    _styleUpdateTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (_mapController != null) {
        _mapController!.setMapStyle(_getMapStyle());
        setState(() {});
      }
    });
  }

  @override
  void didUpdateWidget(ModernRouteMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.originAddress != widget.originAddress ||
        oldWidget.destinationAddress != widget.destinationAddress) {
      _updateMap();
    }
  }

  @override
  void dispose() {
    _styleUpdateTimer?.cancel();
    _slideController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
      _updateMap();
    } catch (e) {
      debugPrint('Erro ao obter localização atual: $e');
      // Se não conseguir a localização atual, usa São Paulo como fallback
      setState(() {
        _currentPosition = const LatLng(-23.5505, -46.6333);
      });
      _updateMap();
    }
  }

  Future<void> _updateMap() async {
    if (!mounted) return;
    
    if (widget.originAddress.isEmpty && widget.destinationAddress.isEmpty) {
      // Se não houver endereços, mostra a localização atual
      _markers = {};
      _polylines = {};
      if (_mapController != null && _currentPosition != null) {
        _mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: _currentPosition!,
              zoom: 14,
            ),
          ),
        );
      }
      return;
    }

    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      // Geocodificar endereços
      List<Location> locations = [];
      if (widget.originAddress.isNotEmpty) {
        locations.addAll(await locationFromAddress(widget.originAddress));
      }
      if (widget.destinationAddress.isNotEmpty) {
        locations.addAll(await locationFromAddress(widget.destinationAddress));
      }

      if (!mounted) return;

      // Criar marcadores
      _markers = {};
      if (locations.isNotEmpty) {
        if (widget.originAddress.isNotEmpty) {
          _markers.add(
            Marker(
              markerId: const MarkerId('origin'),
              position: LatLng(locations[0].latitude, locations[0].longitude),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
              infoWindow: InfoWindow(title: widget.originAddress),
            ),
          );
        }
        if (widget.destinationAddress.isNotEmpty) {
          _markers.add(
            Marker(
              markerId: const MarkerId('destination'),
              position: LatLng(
                locations[widget.originAddress.isNotEmpty ? 1 : 0].latitude,
                locations[widget.originAddress.isNotEmpty ? 1 : 0].longitude,
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
              infoWindow: InfoWindow(title: widget.destinationAddress),
            ),
          );
        }
      }

      // Calcular rota (simulada)
      if (locations.length >= 2) {
        // Simular cálculo de rota
        await Future.delayed(const Duration(seconds: 1));
        if (!mounted) return;
        
        _polylines = {
          Polyline(
            polylineId: const PolylineId('route'),
            points: [
              LatLng(locations[0].latitude, locations[0].longitude),
              LatLng(locations[1].latitude, locations[1].longitude),
            ],
            color: Colors.blue,
            width: 5,
          ),
        };

        // Simular distância e duração
        widget.onRouteCalculated('5.2 km', '15 min');
      }

      // Ajustar câmera
      if (_mapController != null && locations.isNotEmpty) {
        double minLat = locations[0].latitude;
        double maxLat = locations[0].latitude;
        double minLng = locations[0].longitude;
        double maxLng = locations[0].longitude;

        for (var marker in _markers) {
          final lat = marker.position.latitude;
          final lng = marker.position.longitude;
          minLat = minLat < lat ? minLat : lat;
          maxLat = maxLat > lat ? maxLat : lat;
          minLng = minLng < lng ? minLng : lng;
          maxLng = maxLng > lng ? maxLng : lng;
        }

        final bounds = LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        );

        _mapController!.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, 50),
        );
      }
    } catch (e) {
      debugPrint('Erro ao atualizar mapa: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _currentPosition ?? const LatLng(-23.5505, -46.6333),
            zoom: 14,
          ),
          markers: _markers,
          polylines: _polylines,
          onMapCreated: (controller) {
            _mapController = controller;
            _updateMap();
          },
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
        ),
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
