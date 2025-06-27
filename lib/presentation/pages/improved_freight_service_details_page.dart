import 'package:flutter/material.dart';
import 'package:levvu_client/core/models/service_types.dart';
import 'package:levvu_client/presentation/pages/steps/service_type_step.dart';
import 'package:levvu_client/presentation/pages/steps/service_details_step.dart';
import 'package:levvu_client/presentation/pages/steps/photos_step.dart';
import 'package:levvu_client/presentation/widgets/error_message.dart';
import 'package:levvu_client/presentation/widgets/success_message.dart';
import 'package:provider/provider.dart';
import 'package:levvu_client/core/controllers/freight_request_controller.dart';


class ImprovedFreightServiceDetailsPage extends StatefulWidget {
  final Function(EServiceTypes)? onServiceTypeChanged;
  final Function(int)? onStepChanged;

  const ImprovedFreightServiceDetailsPage({
    super.key,
    this.onServiceTypeChanged,
    this.onStepChanged,
  });

  @override
  State<ImprovedFreightServiceDetailsPage> createState() => ImprovedFreightServiceDetailsPageState();
}

class ImprovedFreightServiceDetailsPageState extends State<ImprovedFreightServiceDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  int currentStep = 0;
  EServiceTypes? _selectedServiceType;
  final List<String> _photoUrls = [];

  // Controllers para os campos de texto
  final _descriptionController = TextEditingController();
  final _pickupTimeController = TextEditingController();
  final _deliveryTimeController = TextEditingController();
  final _weightController = TextEditingController();
  final _volumeController = TextEditingController();
  final _quantityController = TextEditingController();
  final _valueController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    _pickupTimeController.dispose();
    _deliveryTimeController.dispose();
    _weightController.dispose();
    _volumeController.dispose();
    _quantityController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  void nextStep() {
    if (currentStep < 2) {
      setState(() {
        currentStep++;
      });
      widget.onStepChanged?.call(currentStep);
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
      widget.onStepChanged?.call(currentStep);
    }
  }

  bool canProceedToNextStep() {
    if (currentStep == 0) {
      return _selectedServiceType != null;
    }
    return true;
  }

  void _addPhoto(String photoUrl) {
    setState(() {
      _photoUrls.add(photoUrl);
    });
  }

  void _removePhoto(int index) {
    setState(() {
      _photoUrls.removeAt(index);
    });
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Solicitação'),
        content: const Text('Tem certeza que deseja finalizar a solicitação?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implementar lógica de finalização
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FreightRequestController>(
      builder: (context, controller, child) {
        return Form(
          key: _formKey,
          child: Column(
            children: [
              // Conteúdo principal
              Expanded(
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
                          ),
                        ),

                      // Seletor de tipo de serviço
                      if (currentStep == 0)
                        ServiceTypeStep(
                          selectedType: _selectedServiceType,
                          onTypeSelected: (type) {
                            setState(() {
                              _selectedServiceType = type;
                            });
                            widget.onServiceTypeChanged?.call(type);
                          },
                        ),

                      // Detalhes do serviço
                      if (currentStep == 1)
                        ServiceDetailsStep(
                          selectedType: _selectedServiceType!,
                          descriptionController: _descriptionController,
                          pickupTimeController: _pickupTimeController,
                          deliveryTimeController: _deliveryTimeController,
                          weightController: _weightController,
                          volumeController: _volumeController,
                          quantityController: _quantityController,
                          valueController: _valueController,
                          onPickupTimeTap: () {
                            // TODO: Implementar seleção de horário
                          },
                          onDeliveryTimeTap: () {
                            // TODO: Implementar seleção de horário
                          },
                        ),

                      // Upload de fotos
                      if (currentStep == 2)
                        PhotosStep(
                          photoUrls: _photoUrls,
                          onPhotoAdded: _addPhoto,
                          onPhotoRemoved: _removePhoto,
                        ),
                    ],
                  ),
                ),
              ),

              // Botões de navegação (apenas para steps 0 e 1)
              if (currentStep < 2)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
