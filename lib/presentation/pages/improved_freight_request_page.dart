import 'package:flutter/material.dart';
import 'package:levvu_client/presentation/widgets/error_dialog.dart';
import 'package:levvu_client/presentation/widgets/freight/address_form.dart';
import 'package:levvu_client/presentation/widgets/freight/address_picker.dart';
import 'package:levvu_client/presentation/pages/improved_freight_service_details_page.dart';
import 'package:levvu_client/presentation/widgets/freight/modern_route_map.dart';
import 'package:levvu_client/presentation/widgets/freight/route_details_card.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

class ImprovedFreightRequestPage extends StatefulWidget {
  const ImprovedFreightRequestPage({super.key});

  @override
  State<ImprovedFreightRequestPage> createState() => _ImprovedFreightRequestPageState();
}

class _ImprovedFreightRequestPageState extends State<ImprovedFreightRequestPage> {
  final _formKey = GlobalKey<FormState>();
  final _pickupAddressController = TextEditingController();
  final _deliveryAddressController = TextEditingController();
  
  String _routeDistance = '';
  String _routeDuration = '';
  int _currentStep = 0;
  String _pickupAddress = '';
  String _deliveryAddress = '';
  final _placesApiKey = "AIzaSyAwV5JLtIB-MzLA7wKUS1WHijzLIsEhhnM";

  @override
  void initState() {
    super.initState();
    _pickupAddressController.text = _pickupAddress;
    _deliveryAddressController.text = _deliveryAddress;
  }

  @override
  void dispose() {
    _pickupAddressController.dispose();
    _deliveryAddressController.dispose();
    super.dispose();
  }
  
  Future<void> _showErrorDialog(String message) async {
    await showDialog(
      context: context,
      builder: (context) => ErrorDialog(
        title: 'Erro',
        message: message,
        buttonText: 'OK',
      ),
    );
  }

  String? _validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo é obrigatório';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitar Frete'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Indicador de progresso
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Row(
              children: [
                _buildStepIndicator(0, 'Endereços', Icons.location_on),
                Expanded(
                  child: Container(
                    height: 2,
                    color: _currentStep > 0 
                      ? Theme.of(context).primaryColor 
                      : Colors.grey.shade300,
                  ),
                ),
                _buildStepIndicator(1, 'Serviço', Icons.local_shipping),
              ],
            ),
          ),
          
          // Conteúdo principal
          Expanded(
            child: _buildStepContent(),
          ),
          
          // Botões de navegação
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousStep,
                      child: const Text('Voltar'),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _canProceedToNextStep() ? _nextStep : null,
                    child: Text(_currentStep == 0 ? 'Próximo' : 'Continuar'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label, IconData icon) {
    final isActive = _currentStep >= step;
    final isCompleted = _currentStep > step;
    
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isActive 
              ? Theme.of(context).primaryColor 
              : Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
          child: Icon(
            isCompleted ? Icons.check : icon,
            color: isActive ? Colors.white : Colors.grey.shade600,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive 
              ? Theme.of(context).primaryColor 
              : Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: _buildAddressStep(),
        );
      case 1:
        return ImprovedFreightServiceDetailsPage(
          pickupAddress: _pickupAddressController.text,
          deliveryAddress: _deliveryAddressController.text,
          routeDistance: _routeDistance,
          routeDuration: _routeDuration,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildAddressStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Mapa
        Container(
          height: 300,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: ModernRouteMap(
              originAddress: _pickupAddress,
              destinationAddress: _deliveryAddress,
              onRouteCalculated: (distance, duration) {
                setState(() {
                  _routeDistance = distance;
                  _routeDuration = duration;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Formulário de endereços
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Endereço de coleta
                Row(
                  children: [
                    Expanded(
                      child: GooglePlaceAutoCompleteTextField(
                        googleAPIKey: _placesApiKey,
                        textEditingController: _pickupAddressController,
                        inputDecoration: InputDecoration(
                          labelText: 'Endereço de coleta',
                          hintText: 'Digite o endereço de coleta',
                          prefixIcon: const Icon(Icons.location_on_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        debounceTime: 800,
                        countries: const ["br"],
                        isLatLngRequired: true,
                        getPlaceDetailWithLatLng: (Prediction prediction) {
                          setState(() {
                            _pickupAddress = prediction.description ?? '';
                          });
                        },
                        itemClick: (Prediction prediction) {
                          setState(() {
                            _pickupAddress = prediction.description ?? '';
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () async {
                        try {
                          final position = await Geolocator.getCurrentPosition();
                          final placemarks = await placemarkFromCoordinates(
                            position.latitude,
                            position.longitude,
                          );
                          if (placemarks.isNotEmpty) {
                            final place = placemarks.first;
                            final address = [
                              if (place.street?.isNotEmpty ?? false) place.street,
                              if (place.subLocality?.isNotEmpty ?? false) place.subLocality,
                              if (place.locality?.isNotEmpty ?? false) place.locality,
                              if (place.administrativeArea?.isNotEmpty ?? false) place.administrativeArea,
                            ].where((e) => e != null).join(', ');
                            
                            setState(() {
                              _pickupAddress = address;
                              _pickupAddressController.text = address;
                            });
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Não foi possível obter sua localização atual'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.my_location),
                      tooltip: 'Usar minha localização atual',
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.blue.shade50,
                        foregroundColor: Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Endereço de entrega
                Row(
                  children: [
                    Expanded(
                      child: GooglePlaceAutoCompleteTextField(
                        googleAPIKey: _placesApiKey,
                        textEditingController: _deliveryAddressController,
                        inputDecoration: InputDecoration(
                          labelText: 'Endereço de entrega',
                          hintText: 'Digite o endereço de entrega',
                          prefixIcon: const Icon(Icons.location_on_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        debounceTime: 800,
                        countries: const ["br"],
                        isLatLngRequired: true,
                        getPlaceDetailWithLatLng: (Prediction prediction) {
                          setState(() {
                            _deliveryAddress = prediction.description ?? '';
                          });
                        },
                        itemClick: (Prediction prediction) {
                          setState(() {
                            _deliveryAddress = prediction.description ?? '';
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () async {
                        try {
                          final position = await Geolocator.getCurrentPosition();
                          final placemarks = await placemarkFromCoordinates(
                            position.latitude,
                            position.longitude,
                          );
                          if (placemarks.isNotEmpty) {
                            final place = placemarks.first;
                            final address = [
                              if (place.street?.isNotEmpty ?? false) place.street,
                              if (place.subLocality?.isNotEmpty ?? false) place.subLocality,
                              if (place.locality?.isNotEmpty ?? false) place.locality,
                              if (place.administrativeArea?.isNotEmpty ?? false) place.administrativeArea,
                            ].where((e) => e != null).join(', ');
                            
                            setState(() {
                              _deliveryAddress = address;
                              _deliveryAddressController.text = address;
                            });
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Não foi possível obter sua localização atual'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.my_location),
                      tooltip: 'Usar minha localização atual',
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.blue.shade50,
                        foregroundColor: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Detalhes da rota
        if (_routeDistance != null && _routeDuration != null)
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Detalhes da rota',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.route, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        'Distância: $_routeDistance',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.timer, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        'Duração estimada: $_routeDuration',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  bool _canProceedToNextStep() {
    switch (_currentStep) {
      case 0:
        return _pickupAddress.isNotEmpty && _deliveryAddress.isNotEmpty;
      case 1:
        return true;
      default:
        return false;
    }
  }

  void _nextStep() {
    if (_currentStep < 1) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }
}

