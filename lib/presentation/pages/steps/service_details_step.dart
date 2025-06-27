import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:levvu_client/core/models/service_types.dart';


class ServiceDetailsStep extends StatelessWidget {
  final EServiceTypes selectedType;
  final TextEditingController descriptionController;
  final TextEditingController pickupTimeController;
  final TextEditingController deliveryTimeController;
  final TextEditingController weightController;
  final TextEditingController volumeController;
  final TextEditingController quantityController;
  final TextEditingController valueController;
  final Function() onPickupTimeTap;
  final Function() onDeliveryTimeTap;

  const ServiceDetailsStep({
    super.key,
    required this.selectedType,
    required this.descriptionController,
    required this.pickupTimeController,
    required this.deliveryTimeController,
    required this.weightController,
    required this.volumeController,
    required this.quantityController,
    required this.valueController,
    required this.onPickupTimeTap,
    required this.onDeliveryTimeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Detalhes do Serviço',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Preencha os detalhes do serviço de ${selectedType.name.toLowerCase()}',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 24),

        // Descrição do serviço
        TextFormField(
          controller: descriptionController,
          decoration: const InputDecoration(
            labelText: 'Descrição do Serviço',
            hintText: 'Descreva o serviço que você precisa',
          ),
          maxLines: 3,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, descreva o serviço';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Horários
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: pickupTimeController,
                decoration: const InputDecoration(
                  labelText: 'Horário de Coleta',
                  hintText: 'Selecione o horário',
                ),
                readOnly: true,
                onTap: onPickupTimeTap,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecione o horário de coleta';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: deliveryTimeController,
                decoration: const InputDecoration(
                  labelText: 'Horário de Entrega',
                  hintText: 'Selecione o horário',
                ),
                readOnly: true,
                onTap: onDeliveryTimeTap,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecione o horário de entrega';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Dimensões e valores
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: weightController,
                decoration: const InputDecoration(
                  labelText: 'Peso (kg)',
                  hintText: '0.0',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o peso';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: volumeController,
                decoration: const InputDecoration(
                  labelText: 'Volume (m³)',
                  hintText: '0.0',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o volume';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantidade',
                  hintText: '1',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a quantidade';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: valueController,
                decoration: const InputDecoration(
                  labelText: 'Valor (R\$)',
                  hintText: '0.00',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o valor';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
} 