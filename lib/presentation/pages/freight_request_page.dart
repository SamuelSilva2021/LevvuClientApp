import 'package:flutter/material.dart';
import 'package:levvu_client/core/controllers/freight_request_controller.dart';
import 'package:levvu_client/core/models/cargo_item_model.dart';
import 'package:levvu_client/core/models/freight_request_model.dart';
import 'package:levvu_client/presentation/widgets/confirmation_dialog.dart';
import 'package:levvu_client/presentation/widgets/error_dialog.dart';
import 'package:levvu_client/presentation/widgets/error_message.dart';
import 'package:levvu_client/presentation/widgets/freight/address_form.dart';
import 'package:levvu_client/presentation/widgets/freight/address_picker.dart';
import 'package:levvu_client/presentation/widgets/freight/cargo_items_form.dart';
import 'package:levvu_client/presentation/widgets/freight/freight_details_form.dart';
import 'package:levvu_client/presentation/widgets/freight/photo_upload.dart';
import 'package:levvu_client/presentation/widgets/loading_button.dart';
import 'package:levvu_client/presentation/widgets/success_message.dart';
import 'package:provider/provider.dart';

class FreightRequestPage extends StatefulWidget {
  const FreightRequestPage({super.key});

  @override
  State<FreightRequestPage> createState() => _FreightRequestPageState();
}

class _FreightRequestPageState extends State<FreightRequestPage> {
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
  bool _helpLoading = false;
  bool _disassemblyAssembly = false;
  bool _specialPackaging = false;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final List<CargoItemModel> _cargoItems = [];
  final List<String> _photoUrls = [];
  final List<String> _imageUrls = [];

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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _updatePickupTime();
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _updatePickupTime();
      });
    }
  }

  void _updatePickupTime() {
    if (_selectedDate != null && _selectedTime != null) {
      final dateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );
      _pickupTimeController.text = dateTime.toIso8601String();
    }
  }

  void _addCargoItem(CargoItemModel item) {
    setState(() {
      _cargoItems.add(item);
    });
  }

  void _removeCargoItem(int index) {
    setState(() {
      _cargoItems.removeAt(index);
    });
  }

  void _addPhoto(String url) {
    setState(() {
      _photoUrls.add(url);
    });
  }

  void _removePhoto(int index) {
    setState(() {
      _photoUrls.removeAt(index);
    });
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

  String? _validateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo é obrigatório';
    }
    if (int.tryParse(value) == null) {
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

      if (!success && mounted) {
        await _showErrorDialog(
            controller.error ?? 'Erro ao criar solicitação de frete');
      } else if (mounted) {
        Navigator.pop(context);
      }
    }
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

  Future<void> _showConfirmationDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'Confirmar Solicitação',
        message: 'Deseja realmente criar esta solicitação de frete?',
        confirmText: 'Sim',
        cancelText: 'Não',
        onConfirm: () {
          Navigator.pop(context, true);
        },
      ),
    );

    if (confirmed == true) {
      await _submitForm();
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
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (controller.error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: ErrorMessage(
                        message: controller.error!,
                        onDismiss: controller.clearError,
                      ),
                    ),
                  if (controller.successMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: SuccessMessage(
                        message: controller.successMessage!,
                        onDismiss: controller.clearSuccessMessage,
                      ),
                    ),
                  AddressForm(
                    pickupAddressController: _pickupAddressController,
                    deliveryAddressController: _deliveryAddressController,
                    onPickupAddressTap: () {
                      _showAddressPicker(context, _pickupAddressController);
                    },
                    onDeliveryAddressTap: () {
                      _showAddressPicker(context, _deliveryAddressController);
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
                    onVehicleTypeChanged: (value) {
                      setState(() {
                        _selectedVehicleType = value;
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
                    validator: _validateRequired,
                    numberValidator: _validateNumber,
                  ),
                  const SizedBox(height: 24),
                  PhotoUpload(
                    photoUrls: _photoUrls,
                    onPhotoAdded: _addPhoto,
                    onPhotoRemoved: _removePhoto,
                  ),
                  const SizedBox(height: 24),
                  CargoItemsForm(
                    items: _cargoItems,
                    onAddItem: _addCargoItem,
                    onRemoveItem: _removeCargoItem,
                  ),
                  const SizedBox(height: 24),
                  LoadingButton(
                    text: 'Criar Solicitação',
                    onPressed: _showConfirmationDialog,
                    isLoading: controller.isLoading,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
