import 'package:flutter/material.dart';
import 'package:levvu_client/core/models/service_types.dart';

class ServiceTypeSelector extends StatelessWidget {
  final EServiceTypes? selectedType;
  final Function(EServiceTypes) onTypeSelected;

  const ServiceTypeSelector({
    super.key,
    this.selectedType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tipo de Serviço',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildServiceTypeCard(
                EServiceTypes.residentialMoving,
                context,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildServiceTypeCard(
                EServiceTypes.expressDelivery,
                context,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildServiceTypeCard(EServiceTypes type, BuildContext context) {
    final isSelected = selectedType == type;

    return InkWell(
      onTap: () => onTypeSelected(type),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              type == EServiceTypes.residentialMoving
                  ? Icons.home_work_outlined
                  : Icons.local_shipping_outlined,
              size: 48,
              color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
            ),
            const SizedBox(height: 8),
            Text(
              type.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Theme.of(context).primaryColor : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 