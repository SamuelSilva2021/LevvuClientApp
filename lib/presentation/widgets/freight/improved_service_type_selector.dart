import 'package:flutter/material.dart';
import 'package:levvu_client/core/models/service_types.dart';

class ImprovedServiceTypeSelector extends StatefulWidget {
  final EServiceTypes? selectedType;
  final Function(EServiceTypes) onTypeSelected;

  const ImprovedServiceTypeSelector({
    super.key,
    this.selectedType,
    required this.onTypeSelected,
  });

  @override
  State<ImprovedServiceTypeSelector> createState() => _ImprovedServiceTypeSelectorState();
}

class _ImprovedServiceTypeSelectorState extends State<ImprovedServiceTypeSelector> {
  ServiceCategory? selectedCategory;
  EServiceTypes? selectedServiceType;

  @override
  void initState() {
    super.initState();
    selectedServiceType = widget.selectedType;
    if (selectedServiceType != null) {
      selectedCategory = selectedServiceType!.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tipo de Serviço',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        // Primeira etapa: Seleção de categoria
        if (selectedCategory == null) ...[
          const Text(
            'Selecione a categoria do seu serviço:',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          _buildCategoryGrid(),
        ],
        
        // Segunda etapa: Seleção do tipo específico
        if (selectedCategory != null) ...[
          _buildCategoryHeader(),
          const SizedBox(height: 16),
          _buildServiceTypeList(),
        ],
      ],
    );
  }

  Widget _buildCategoryGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: ServiceCategory.values.length,
      itemBuilder: (context, index) {
        final category = ServiceCategory.values[index];
        return _buildCategoryCard(category);
      },
    );
  }

  Widget _buildCategoryCard(ServiceCategory category) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedCategory = category;
          selectedServiceType = null;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getIconData(category.icon),
              size: 32,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 4),
            Text(
              category.label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              category.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _getIconData(selectedCategory!.icon),
            color: Theme.of(context).primaryColor,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedCategory!.label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Text(
                  'Selecione o tipo específico:',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                selectedCategory = null;
                selectedServiceType = null;
              });
            },
            icon: const Icon(Icons.edit_outlined),
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildServiceTypeList() {
    final serviceTypes = EServiceTypes.getByCategory(selectedCategory!);
    
    return Column(
      children: serviceTypes.map((serviceType) {
        return _buildServiceTypeCard(serviceType);
      }).toList(),
    );
  }

  Widget _buildServiceTypeCard(EServiceTypes serviceType) {
    final isSelected = selectedServiceType == serviceType;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          setState(() {
            selectedServiceType = serviceType;
          });
          widget.onTypeSelected(serviceType);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected 
                    ? Theme.of(context).primaryColor 
                    : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getIconData(serviceType.icon),
                  color: isSelected ? Colors.white : Colors.grey.shade600,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      serviceType.label,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Theme.of(context).primaryColor : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      serviceType.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Icon(
                    Icons.check_circle,
                    color: Theme.of(context).primaryColor,
                    size: 24,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'home_work_outlined':
        return Icons.home_work_outlined;
      case 'business_outlined':
        return Icons.business_outlined;
      case 'chair_outlined':
        return Icons.chair_outlined;
      case 'bed_outlined':
        return Icons.bed_outlined;
      case 'shelves_outlined':
        return Icons.shelves;
      case 'table_restaurant_outlined':
        return Icons.table_restaurant_outlined;
      case 'kitchen_outlined':
        return Icons.kitchen_outlined;
      case 'tv_outlined':
        return Icons.tv_outlined;
      case 'ac_unit_outlined':
        return Icons.ac_unit_outlined;
      case 'local_shipping_outlined':
        return Icons.local_shipping_outlined;
      case 'description_outlined':
        return Icons.description_outlined;
      case 'restaurant_outlined':
        return Icons.restaurant_outlined;
      case 'construction_outlined':
        return Icons.construction_outlined;
      case 'build_outlined':
        return Icons.build_outlined;
      case 'category_outlined':
        return Icons.category_outlined;
      default:
        return Icons.help_outline;
    }
  }
}

