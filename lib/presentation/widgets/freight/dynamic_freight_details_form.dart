import 'package:flutter/material.dart';
import 'package:levvu_client/core/models/service_types.dart';

class DynamicFreightDetailsForm extends StatefulWidget {
  final TextEditingController descriptionController;
  final TextEditingController cargoTypeController;
  final TextEditingController weightController;
  final TextEditingController volumeController;
  final TextEditingController pickupTimeController;
  final TextEditingController itemDescriptionController;
  final TextEditingController observationsController;
  final EServiceTypes selectedServiceType;
  final Function(dynamic) onVehicleTypeChanged;
  final Function(bool) onHelpLoadingChanged;
  final Function(bool) onDisassemblyAssemblyChanged;
  final Function(bool) onSpecialPackagingChanged;
  final String? Function(String?) validator;
  final String? Function(String?) numberValidator;

  const DynamicFreightDetailsForm({
    super.key,
    required this.descriptionController,
    required this.cargoTypeController,
    required this.weightController,
    required this.volumeController,
    required this.pickupTimeController,
    required this.itemDescriptionController,
    required this.observationsController,
    required this.selectedServiceType,
    required this.onVehicleTypeChanged,
    required this.onHelpLoadingChanged,
    required this.onDisassemblyAssemblyChanged,
    required this.onSpecialPackagingChanged,
    required this.validator,
    required this.numberValidator,
  });

  @override
  State<DynamicFreightDetailsForm> createState() => _DynamicFreightDetailsFormState();
}

class _DynamicFreightDetailsFormState extends State<DynamicFreightDetailsForm> {
  // Controladores específicos para campos dinâmicos
  final _roomsController = TextEditingController();
  final _floorController = TextEditingController();
  final _dimensionsController = TextEditingController();
  final _brandModelController = TextEditingController();
  final _declaredValueController = TextEditingController();
  
  bool _hasElevator = false;
  bool _needsDisassembly = false;
  bool _needsInstallation = false;
  bool _isApartment = false;
  bool _urgentDelivery = false;
  bool _needsSignature = false;

  @override
  void dispose() {
    _roomsController.dispose();
    _floorController.dispose();
    _dimensionsController.dispose();
    _brandModelController.dispose();
    _declaredValueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Detalhes do Serviço',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        // Campos comuns
        _buildCommonFields(),
        
        const SizedBox(height: 24),
        
        // Campos específicos baseados no tipo de serviço
        _buildSpecificFields(),
        
        const SizedBox(height: 24),
        
        // Serviços adicionais
        _buildAdditionalServices(),
      ],
    );
  }

  Widget _buildCommonFields() {
    return Column(
      children: [
        TextFormField(
          controller: widget.descriptionController,
          decoration: const InputDecoration(
            labelText: 'Descrição Geral',
            hintText: 'Descreva brevemente o que será transportado',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          validator: widget.validator,
        ),
        const SizedBox(height: 16),
        
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: widget.weightController,
                decoration: const InputDecoration(
                  labelText: 'Peso Estimado (kg)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: widget.numberValidator,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: widget.volumeController,
                decoration: const InputDecoration(
                  labelText: 'Volume (m³)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: widget.numberValidator,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSpecificFields() {
    switch (widget.selectedServiceType.category) {
      case ServiceCategory.moving:
        return _buildMovingFields();
      case ServiceCategory.furniture:
        return _buildFurnitureFields();
      case ServiceCategory.appliances:
        return _buildApplianceFields();
      case ServiceCategory.express:
        return _buildExpressFields();
      case ServiceCategory.construction:
        return _buildConstructionFields();
      default:
        return _buildOtherFields();
    }
  }

  Widget _buildMovingFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Detalhes da Mudança',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _roomsController,
                decoration: const InputDecoration(
                  labelText: 'Número de Cômodos',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: widget.numberValidator,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _floorController,
                decoration: const InputDecoration(
                  labelText: 'Andar',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        SwitchListTile(
          title: const Text('É apartamento?'),
          value: _isApartment,
          onChanged: (value) {
            setState(() {
              _isApartment = value;
            });
          },
        ),
        
        if (_isApartment)
          SwitchListTile(
            title: const Text('Tem elevador?'),
            value: _hasElevator,
            onChanged: (value) {
              setState(() {
                _hasElevator = value;
              });
            },
          ),
      ],
    );
  }

  Widget _buildFurnitureFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Detalhes do Móvel',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        TextFormField(
          controller: _dimensionsController,
          decoration: const InputDecoration(
            labelText: 'Dimensões Aproximadas',
            hintText: 'Ex: 2m x 1m x 0,8m',
            border: OutlineInputBorder(),
          ),
          validator: widget.validator,
        ),
        const SizedBox(height: 16),
        
        SwitchListTile(
          title: const Text('Necessita desmontagem/montagem?'),
          value: _needsDisassembly,
          onChanged: (value) {
            setState(() {
              _needsDisassembly = value;
            });
            widget.onDisassemblyAssemblyChanged(value);
          },
        ),
      ],
    );
  }

  Widget _buildApplianceFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Detalhes do Eletrodoméstico',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        TextFormField(
          controller: _brandModelController,
          decoration: const InputDecoration(
            labelText: 'Marca e Modelo',
            hintText: 'Ex: Samsung RF23R62E3SR',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        
        SwitchListTile(
          title: const Text('Necessita desinstalação/instalação?'),
          value: _needsInstallation,
          onChanged: (value) {
            setState(() {
              _needsInstallation = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildExpressFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Detalhes da Entrega',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        TextFormField(
          controller: _declaredValueController,
          decoration: const InputDecoration(
            labelText: 'Valor Declarado (R\$)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        
        SwitchListTile(
          title: const Text('Entrega urgente?'),
          value: _urgentDelivery,
          onChanged: (value) {
            setState(() {
              _urgentDelivery = value;
            });
          },
        ),
        
        SwitchListTile(
          title: const Text('Necessita assinatura do destinatário?'),
          value: _needsSignature,
          onChanged: (value) {
            setState(() {
              _needsSignature = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildConstructionFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Detalhes dos Materiais',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        TextFormField(
          controller: widget.cargoTypeController,
          decoration: const InputDecoration(
            labelText: 'Tipo de Material',
            hintText: 'Ex: Cimento, tijolos, areia',
            border: OutlineInputBorder(),
          ),
          validator: widget.validator,
        ),
      ],
    );
  }

  Widget _buildOtherFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Detalhes Adicionais',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        TextFormField(
          controller: widget.itemDescriptionController,
          decoration: const InputDecoration(
            labelText: 'Descrição Detalhada',
            hintText: 'Descreva o item em detalhes',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          validator: widget.validator,
        ),
      ],
    );
  }

  Widget _buildAdditionalServices() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Serviços Adicionais',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        SwitchListTile(
          title: const Text('Ajuda para carregar/descarregar'),
          subtitle: const Text('Serviço de ajudantes para o transporte'),
          value: false,
          onChanged: widget.onHelpLoadingChanged,
        ),
        
        SwitchListTile(
          title: const Text('Embalagem especial'),
          subtitle: const Text('Proteção extra para itens frágeis'),
          value: false,
          onChanged: widget.onSpecialPackagingChanged,
        ),
        
        const SizedBox(height: 16),
        
        TextFormField(
          controller: widget.observationsController,
          decoration: const InputDecoration(
            labelText: 'Observações Gerais',
            hintText: 'Informações adicionais importantes',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
      ],
    );
  }
}

