import 'package:flutter/material.dart';
import 'package:levvu_client/core/services/geocoding/geocoding_service.dart';
import 'package:levvu_client/presentation/widgets/custom_text_field.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:async';
import 'dart:developer' as developer;

class AddressPicker extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final Function(String) onAddressSelected;

  const AddressPicker({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.onAddressSelected,
  });

  @override
  State<AddressPicker> createState() => _AddressPickerState();
}

class _AddressPickerState extends State<AddressPicker> {
  final _searchController = TextEditingController();
  final List<Map<String, dynamic>> _suggestions = [];
  bool _isLoading = false;
  String? _statusMessage;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Verificando serviço de localização...';
    });

    try {
      // Verifica se o serviço de localização está ativado
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      developer.log('Serviço de localização ativado: $serviceEnabled');

      if (!serviceEnabled) {
        throw Exception(
            'O serviço de localização está desativado. Por favor, ative o GPS.');
      }

      setState(() {
        _statusMessage = 'Verificando permissões...';
      });

      // Verifica permissão de localização
      LocationPermission permission = await Geolocator.checkPermission();
      developer.log('Permissão inicial: $permission');

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        developer.log('Permissão após solicitação: $permission');

        if (permission == LocationPermission.denied) {
          throw Exception(
              'Permissão de localização negada. Por favor, permita o acesso à localização nas configurações do aplicativo.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
            'Permissão de localização permanentemente negada. Por favor, permita o acesso à localização nas configurações do aplicativo.');
      }

      setState(() {
        _statusMessage = 'Obtendo localização atual...';
      });

      // Obtém a posição atual
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      developer
          .log('Posição obtida: ${position.latitude}, ${position.longitude}');

      setState(() {
        _statusMessage = 'Convertendo coordenadas em endereço...';
      });

      // Converte as coordenadas em endereço
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      developer.log('Placemarks obtidos: ${placemarks.length}');

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final address = [
          if (place.street?.isNotEmpty ?? false) place.street,
          if (place.subLocality?.isNotEmpty ?? false) place.subLocality,
          if (place.locality?.isNotEmpty ?? false) place.locality,
          if (place.administrativeArea?.isNotEmpty ?? false)
            place.administrativeArea,
          if (place.country?.isNotEmpty ?? false) place.country,
        ].where((s) => s != null).join(', ');

        developer.log('Endereço obtido: $address');

        if (address.isEmpty) {
          throw Exception(
              'Não foi possível obter o endereço atual. Por favor, tente novamente.');
        }

        widget.controller.text = address;
        widget.onAddressSelected(address);
        Navigator.pop(context);
      } else {
        throw Exception(
            'Não foi possível obter o endereço atual. Por favor, tente novamente.');
      }
    } on TimeoutException {
      developer.log('Timeout ao obter localização');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Tempo esgotado ao obter localização. Por favor, verifique se o GPS está ativado e tente novamente.'),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      developer.log('Erro ao obter localização: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
        _statusMessage = null;
      });
    }
  }

  Future<void> _searchAddress(String query) async {
    if (query.isEmpty) {
      setState(() {
        _suggestions.clear();
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final suggestions = await GeocodingService.searchAddress(query);
      setState(() {
        _suggestions.clear();
        _suggestions.addAll(suggestions);
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectAddress(Map<String, dynamic> suggestion) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final details =
          await GeocodingService.getPlaceDetails(suggestion['placeId']);
      if (details != null) {
        widget.controller.text = details['address'];
        widget.onAddressSelected(details['address']);
        Navigator.pop(context);
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: _searchController,
                label: 'Buscar Endereço',
                hint: 'Digite o endereço',
                onChanged: _searchAddress,
                prefixIcon: const Icon(Icons.search),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: _isLoading ? null : _getCurrentLocation,
              icon: const Icon(Icons.my_location),
              tooltip: 'Usar minha localização',
            ),
          ],
        ),
        if (_isLoading || _statusMessage != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const CircularProgressIndicator(),
                if (_statusMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _statusMessage!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        if (_suggestions.isNotEmpty)
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _suggestions.length,
              itemBuilder: (context, index) {
                final suggestion = _suggestions[index];
                final description = suggestion['description'] as String;
                final parts = description.split(', ');

                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: ListTile(
                    leading: const Icon(Icons.location_on, color: Colors.red),
                    title: Text(
                      parts.first,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      parts.skip(1).join(', '),
                      style: const TextStyle(fontSize: 12),
                    ),
                    onTap: () => _selectAddress(suggestion),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
