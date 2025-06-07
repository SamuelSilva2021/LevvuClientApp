import 'package:flutter/material.dart';
import 'package:levvu_client/presentation/widgets/error_dialog.dart';
import 'package:levvu_client/presentation/widgets/freight/address_form.dart';
import 'package:levvu_client/presentation/widgets/freight/address_picker.dart';
import 'package:levvu_client/presentation/pages/improved_freight_service_details_page.dart';
import 'package:levvu_client/presentation/widgets/freight/modern_route_map.dart';
import 'package:levvu_client/presentation/widgets/freight/route_details_card.dart';

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

  Future<void> _showAddressPicker(
      BuildContext context, TextEditingController controller) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Selecione um endereço',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: AddressPicker(
                  controller: controller,
                  label: 'Endereço',
                  hint: 'Digite o endereço',
                  onAddressSelected: (address) {
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToServiceDetails() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImprovedFreightServiceDetailsPage(
          pickupAddress: _pickupAddressController.text,
          deliveryAddress: _deliveryAddressController.text,
          routeDistance: _routeDistance,
          routeDuration: _routeDuration,
        ),
      ),
    );
  }

  bool _canProceedToNextStep() {
    switch (_currentStep) {
      case 0:
        return _pickupAddressController.text.isNotEmpty && 
               _deliveryAddressController.text.isNotEmpty;
      case 1:
        return _routeDistance.isNotEmpty && _routeDuration.isNotEmpty;
      default:
        return false;
    }
  }

  void _nextStep() {
    if (_canProceedToNextStep()) {
      if (_currentStep == 1) {
        _navigateToServiceDetails();
      } else {
        setState(() {
          _currentStep++;
        });
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
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
                _buildStepIndicator(1, 'Rota', Icons.route),
                Expanded(
                  child: Container(
                    height: 2,
                    color: _currentStep > 1 
                      ? Theme.of(context).primaryColor 
                      : Colors.grey.shade300,
                  ),
                ),
                _buildStepIndicator(2, 'Serviço', Icons.local_shipping),
              ],
            ),
          ),
          
          // Conteúdo principal
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _buildStepContent(),
              ),
            ),
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
                    child: Text(_currentStep == 1 ? 'Continuar' : 'Próximo'),
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
        return _buildAddressStep();
      case 1:
        return _buildRouteStep();
      default:
        return Container();
    }
  }

  Widget _buildAddressStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Endereços de Coleta e Entrega',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Informe os endereços de origem e destino para calcular a rota.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 24),
        
        AddressForm(
          pickupAddressController: _pickupAddressController,
          deliveryAddressController: _deliveryAddressController,
          onPickupAddressTap: () => _showAddressPicker(
            context,
            _pickupAddressController,
          ),
          onDeliveryAddressTap: () => _showAddressPicker(
            context,
            _deliveryAddressController,
          ),
        ),
        
        if (_pickupAddressController.text.isNotEmpty && 
            _deliveryAddressController.text.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 24),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green.shade600,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Endereços definidos! Clique em "Próximo" para visualizar a rota.',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildRouteStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rota Calculada',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Verifique a rota calculada e confirme para prosseguir.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 24),
        
        // Mapa da rota
        Container(
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: ModernRouteMap(
              originAddress: _pickupAddressController.text,
              destinationAddress: _deliveryAddressController.text,
              onRouteCalculated: (distance, duration) {
                setState(() {
                  _routeDistance = distance;
                  _routeDuration = duration;
                });
              },
            ),
          ),
        ),
        
        if (_routeDistance.isNotEmpty && _routeDuration.isNotEmpty) ...[
          const SizedBox(height: 24),
          RouteDetailsCard(
            distance: _routeDistance,
            duration: _routeDuration,
            originAddress: _pickupAddressController.text,
            destinationAddress: _deliveryAddressController.text,
            onClose: () {
              // Não faz nada, pois o card está sempre visível
            },
            onConfirm: () {
              // Não faz nada, usa o botão de navegação
            },
          ),
        ],
      ],
    );
  }
}

