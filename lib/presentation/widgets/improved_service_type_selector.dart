import 'package:flutter/material.dart';
import 'package:levvu_client/core/models/service_types.dart';

class ImprovedServiceTypeSelector extends StatelessWidget {
  final EServiceTypes? selectedType;
  final Function(EServiceTypes) onTypeSelected;

  const ImprovedServiceTypeSelector({
    super.key,
    required this.selectedType,
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
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Selecione o tipo de serviço que você precisa',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: EServiceTypes.values.map((type) {
            final isSelected = selectedType == type;
            return InkWell(
              onTap: () => onTypeSelected(type),
              child: Container(
                width: 150,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade300,
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getIconForType(type),
                      size: 32,
                      color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade600,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      type.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  IconData _getIconForType(EServiceTypes type) {
    switch (type) {
      case EServiceTypes.residentialMoving:
        return Icons.home;
      case EServiceTypes.commercialMoving:
        return Icons.business;
      case EServiceTypes.furnitureSofa:
      case EServiceTypes.furnitureBed:
      case EServiceTypes.furnitureWardrobe:
      case EServiceTypes.furnitureTable:
        return Icons.chair;
      case EServiceTypes.applianceWhite:
      case EServiceTypes.applianceBrown:
      case EServiceTypes.applianceAC:
        return Icons.kitchen;
      case EServiceTypes.expressDelivery:
      case EServiceTypes.expressDocument:
      case EServiceTypes.expressFood:
        return Icons.local_shipping;
      case EServiceTypes.constructionMaterial:
      case EServiceTypes.constructionTools:
        return Icons.construction;
      case EServiceTypes.other:
        return Icons.category;
    }
  }
} 