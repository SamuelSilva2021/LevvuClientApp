import 'package:flutter/material.dart';
import 'package:levvu_client/core/models/service_types.dart';
import 'package:levvu_client/presentation/widgets/freight/improved_service_type_selector.dart';

class ServiceTypeStep extends StatelessWidget {
  final EServiceTypes? selectedType;
  final Function(EServiceTypes) onTypeSelected;

  const ServiceTypeStep({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ImprovedServiceTypeSelector(
      selectedType: selectedType,
      onTypeSelected: onTypeSelected,
    );
  }
} 