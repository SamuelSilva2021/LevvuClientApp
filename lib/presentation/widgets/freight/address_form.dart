import 'package:flutter/material.dart';
import 'package:levvu_client/presentation/widgets/custom_text_field.dart';

class AddressForm extends StatelessWidget {
  final TextEditingController pickupAddressController;
  final TextEditingController deliveryAddressController;
  final VoidCallback onPickupAddressTap;
  final VoidCallback onDeliveryAddressTap;
  final String? Function(String?)? validator;

  const AddressForm({
    super.key,
    required this.pickupAddressController,
    required this.deliveryAddressController,
    required this.onPickupAddressTap,
    required this.onDeliveryAddressTap,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Endereços',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: pickupAddressController,
          label: 'Endereço de Coleta',
          hint: 'Selecione o endereço de coleta',
          readOnly: true,
          onTap: onPickupAddressTap,
          suffixIcon: const Icon(Icons.location_on, color: Colors.green),
          validator: validator,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: deliveryAddressController,
          label: 'Endereço de Entrega',
          hint: 'Selecione o endereço de entrega',
          readOnly: true,
          onTap: onDeliveryAddressTap,
          suffixIcon: const Icon(Icons.location_on, color: Colors.red),
          validator: validator,
        ),
      ],
    );
  }
}
