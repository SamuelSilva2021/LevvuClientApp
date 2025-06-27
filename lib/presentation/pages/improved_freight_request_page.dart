import 'package:flutter/material.dart';
import 'package:levvu_client/presentation/widgets/error_dialog.dart';
import 'package:levvu_client/presentation/pages/improved_freight_service_details_page.dart';
import 'package:levvu_client/presentation/widgets/freight/modern_route_map.dart';
import 'package:levvu_client/presentation/widgets/freight/address_picker.dart';

class ImprovedFreightRequestPage extends StatefulWidget {
  const ImprovedFreightRequestPage({super.key});

  @override
  State<ImprovedFreightRequestPage> createState() => _ImprovedFreightRequestPageState();
}

class _ImprovedFreightRequestPageState extends State<ImprovedFreightRequestPage> {
  final _formKey = GlobalKey<FormState>();
  final _pickupAddressController = TextEditingController();
  final _deliveryAddressController = TextEditingController();
  final PageController _pageController = PageController();
  final _serviceDetailsKey = GlobalKey<ImprovedFreightServiceDetailsPageState>();
  
  String _routeDistance = '';
  String _routeDuration = '';
  int _currentStep = 0;
  String _pickupAddress = '';
  String _deliveryAddress = '';

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
    _pageController.dispose();
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
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Indicador de progresso
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.05),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                _buildStepIndicator(0, _getStepLabel(0), _getStepIcon(0)),
                Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _currentStep > 0 
                          ? [Theme.of(context).primaryColor, Theme.of(context).primaryColor]
                          : [Colors.grey.shade300, Colors.grey.shade300],
                      ),
                    ),
                  ),
                ),
                _buildStepIndicator(1, _getStepLabel(1), _getStepIcon(1)),
                Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _currentStep > 1 
                          ? [Theme.of(context).primaryColor, Theme.of(context).primaryColor]
                          : [Colors.grey.shade300, Colors.grey.shade300],
                      ),
                    ),
                  ),
                ),
                _buildStepIndicator(2, _getStepLabel(2), _getStepIcon(2)),
              ],
            ),
          ),
          
          // Conteúdo principal
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentStep = index;
                });
              },
              children: [
                // Step 1: Endereços
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _buildAddressStep(),
                ),
                // Step 2: Tipo de Serviço
                ImprovedFreightServiceDetailsPage(
                  key: _serviceDetailsKey,
                  onServiceTypeChanged: (type) {
                    setState(() {}); // Força a reconstrução do widget para atualizar o estado do botão
                  },
                  onStepChanged: (step) {
                    setState(() {
                      _currentStep = step + 1; // +1 porque o step 0 do ImprovedFreightServiceDetailsPage é o step 1 do ImprovedFreightRequestPage
                    });
                  },
                ),
                // Step 3: Detalhes do Serviço
                const SizedBox(), // Placeholder para o próximo step
              ],
            ),
          ),
          
          // Botões de navegação
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
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
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Theme.of(context).primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Voltar'),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _canProceedToNextStep() ? _nextStep : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      _currentStep == 2 ? 'Finalizar' : 'Próximo',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isActive 
              ? Theme.of(context).primaryColor 
              : Colors.grey.shade200,
            shape: BoxShape.circle,
            boxShadow: isActive ? [
              BoxShadow(
                color: Theme.of(context).primaryColor.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ] : null,
          ),
          child: Icon(
            isCompleted ? Icons.check : icon,
            color: isActive ? Colors.white : Colors.grey.shade600,
            size: 24,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive 
              ? Theme.of(context).primaryColor 
              : Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Future<void> _showAddressPicker(BuildContext context, TextEditingController controller, Function(String) onAddressSelected) async {
    await showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Selecione o endereço',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: SingleChildScrollView(
                    child: SizedBox(
                      height: 300,
                      child: AddressPicker(
                        controller: controller,
                        label: 'Endereço',
                        hint: 'Digite o endereço',
                        onAddressSelected: onAddressSelected,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddressStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Mapa
          Container(
            height: 300,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
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
          const SizedBox(height: 24),

          // Card de endereços
          Card(
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Endereços',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Endereço de coleta
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _pickupAddressController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Endereço de coleta',
                            hintText: 'Digite o endereço de coleta',
                            prefixIcon: const Icon(Icons.location_on_outlined),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.my_location),
                              onPressed: () => _showAddressPicker(
                                context,
                                _pickupAddressController,
                                (address) {
                                  setState(() {
                                    _pickupAddress = address;
                                  });
                                },
                              ),
                            ),
                          ),
                          onTap: () => _showAddressPicker(
                            context,
                            _pickupAddressController,
                            (address) {
                              setState(() {
                                _pickupAddress = address;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Endereço de entrega
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _deliveryAddressController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Endereço de entrega',
                            hintText: 'Digite o endereço de entrega',
                            prefixIcon: const Icon(Icons.location_on_outlined),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.my_location),
                              onPressed: () => _showAddressPicker(
                                context,
                                _deliveryAddressController,
                                (address) {
                                  setState(() {
                                    _deliveryAddress = address;
                                  });
                                },
                              ),
                            ),
                          ),
                          onTap: () => _showAddressPicker(
                            context,
                            _deliveryAddressController,
                            (address) {
                              setState(() {
                                _deliveryAddress = address;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteInfo(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  String _getStepLabel(int step) {
    switch (step) {
      case 0:
        return 'Endereços';
      case 1:
        return 'Tipo';
      case 2:
        return 'Serviço';
      default:
        return '';
    }
  }

  IconData _getStepIcon(int step) {
    switch (step) {
      case 0:
        return Icons.location_on;
      case 1:
        return Icons.category;
      case 2:
        return Icons.local_shipping;
      default:
        return Icons.circle;
    }
  }

  bool _canProceedToNextStep() {
    switch (_currentStep) {
      case 0:
        return _pickupAddress.isNotEmpty && _deliveryAddress.isNotEmpty;
      case 1:
        return _serviceDetailsKey.currentState?.canProceedToNextStep() ?? false;
      case 2:
        return true; // Adicione sua validação aqui
      default:
        return false;
    }
  }

  void _nextStep() {
    if (_currentStep == 1) {
      if (_serviceDetailsKey.currentState?.canProceedToNextStep() ?? false) {
        _serviceDetailsKey.currentState?.nextStep();
      }
    } else if (_currentStep < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep == 1 && (_serviceDetailsKey.currentState?.currentStep ?? 0) > 0) {
      _serviceDetailsKey.currentState?.previousStep();
    } else if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}

