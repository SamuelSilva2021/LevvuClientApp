import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:levvu_client/core/controllers/freight_request_controller.dart';
import 'package:levvu_client/core/models/freight_request_model.dart';
import 'package:levvu_client/presentation/widgets/freight/address_form.dart';
import 'package:levvu_client/presentation/widgets/freight/freight_details_form.dart';
import 'package:levvu_client/presentation/widgets/freight/cargo_items_form.dart';
import 'package:levvu_client/presentation/widgets/loading_button.dart';
import 'package:levvu_client/presentation/widgets/confirmation_dialog.dart';
import 'package:levvu_client/presentation/widgets/error_dialog.dart';

class FreightRequestScreen extends StatefulWidget {
  const FreightRequestScreen({super.key});

  @override
  State<FreightRequestScreen> createState() => _FreightRequestScreenState();
}

class _FreightRequestScreenState extends State<FreightRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pickupAddressController = TextEditingController();
  final _deliveryAddressController = TextEditingController();
  final _serviceTypeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _cargoTypeController = TextEditingController();
  final _weightController = TextEditingController();
  final _volumeController = TextEditingController();
  final _pickupTimeController = TextEditingController();
  final _itemDescriptionController = TextEditingController();
  final _observationsController = TextEditingController();
  VehicleType _selectedVehicleType = VehicleType.van;
  DateTime _selectedDate = DateTime.now();
  bool _helpLoading = false;
  bool _disassemblyAssembly = false;
  bool _specialPackaging = false;

  @override
  void dispose() {
    _pickupAddressController.dispose();
    _deliveryAddressController.dispose();
    _serviceTypeController.dispose();
    _descriptionController.dispose();
    _cargoTypeController.dispose();
    _weightController.dispose();
    _volumeController.dispose();
    _pickupTimeController.dispose();
    _itemDescriptionController.dispose();
    _observationsController.dispose();
    super.dispose();
  }

  String? _validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo é obrigatório';
    }
    return null;
  }

  String? _validateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo é obrigatório';
    }
    if (double.tryParse(value) == null) {
      return 'Digite um número válido';
    }
    return null;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final controller = context.read<FreightRequestController>();
      final request = FreightRequestModel(
        pickupAddress: _pickupAddressController.text,
        deliveryAddress: _deliveryAddressController.text,
        vehicleType: _selectedVehicleType,
        serviceType: _serviceTypeController.text,
        description: _descriptionController.text,
        cargoType: _cargoTypeController.text,
        weight: double.parse(_weightController.text),
        volume: double.parse(_volumeController.text),
        withdrawalDate: _selectedDate ?? DateTime.now(),
        pickupTime: _pickupTimeController.text,
        helpLoading: _helpLoading,
        disassemblyAssembly: _disassemblyAssembly,
        specialPackaging: _specialPackaging,
        itemDescription: _itemDescriptionController.text,
        observations: _observationsController.text,
        photoUrls: [],
        imageUrls: [],
        cargoItems: [],
      );
      final success = await controller.createFreightRequest(request);

      if (success && mounted) {
        await showDialog(
          context: context,
          builder: (context) => ConfirmationDialog(
            title: 'Sucesso',
            message: 'Solicitação de frete criada com sucesso!',
            confirmText: 'OK',
            cancelText: 'Cancelar',
            onConfirm: () {
              Navigator.pop(context);
              if (mounted) {
                Navigator.pop(context);
              }
            },
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Solicitação de Frete'),
      ),
      body: Consumer<FreightRequestController>(
        builder: (context, controller, child) {
          if (controller.error != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                builder: (context) => ErrorDialog(
                  title: 'Erro',
                  message: controller.error!,
                  buttonText: 'OK',
                ),
              );
            });
          }

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                AddressForm(
                  pickupAddressController: _pickupAddressController,
                  deliveryAddressController: _deliveryAddressController,
                  onPickupAddressTap: () {
                    // TODO: Implementar seleção de endereço
                  },
                  onDeliveryAddressTap: () {
                    // TODO: Implementar seleção de endereço
                  },
                  validator: _validateRequired,
                ),
                const SizedBox(height: 24),
                FreightDetailsForm(
                  serviceTypeController: _serviceTypeController,
                  descriptionController: _descriptionController,
                  cargoTypeController: _cargoTypeController,
                  weightController: _weightController,
                  volumeController: _volumeController,
                  pickupTimeController: _pickupTimeController,
                  itemDescriptionController: _itemDescriptionController,
                  observationsController: _observationsController,
                  validator: _validateRequired,
                  numberValidator: _validateNumber,
                  onVehicleTypeChanged: (value) {
                    setState(() {
                      _selectedVehicleType = value;
                    });
                  },
                  onWithdrawalDateChanged: (value) {
                    setState(() {
                      _selectedDate = value;
                    });
                  },
                  onHelpLoadingChanged: (value) {
                    setState(() {
                      _helpLoading = value;
                    });
                  },
                  onDisassemblyAssemblyChanged: (value) {
                    setState(() {
                      _disassemblyAssembly = value;
                    });
                  },
                  onSpecialPackagingChanged: (value) {
                    setState(() {
                      _specialPackaging = value;
                    });
                  },
                ),
                const SizedBox(height: 24),
                CargoItemsForm(
                  items: controller.cargoItems,
                  onAddItem: controller.addCargoItem,
                  onRemoveItem: controller.removeCargoItem,
                  validator: _validateRequired,
                  numberValidator: _validateNumber,
                ),
                const SizedBox(height: 24),
                LoadingButton(
                  isLoading: controller.isLoading,
                  onPressed: _submitForm,
                  text: 'Criar Solicitação',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
