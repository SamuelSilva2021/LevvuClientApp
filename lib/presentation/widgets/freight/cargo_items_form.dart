import 'package:flutter/material.dart';
import 'package:levvu_client/core/models/cargo_item_model.dart';
import 'package:levvu_client/presentation/widgets/custom_text_field.dart';

class CargoItemsForm extends StatefulWidget {
  final List<CargoItemModel> items;
  final Function(CargoItemModel) onAddItem;
  final Function(int) onRemoveItem;
  final String? Function(String?)? validator;
  final String? Function(String?)? numberValidator;

  const CargoItemsForm({
    super.key,
    required this.items,
    required this.onAddItem,
    required this.onRemoveItem,
    this.validator,
    this.numberValidator,
  });

  @override
  State<CargoItemsForm> createState() => _CargoItemsFormState();
}

class _CargoItemsFormState extends State<CargoItemsForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitWeightController = TextEditingController();
  final _unitVolumeController = TextEditingController();
  final _lengthController = TextEditingController();
  final _widthController = TextEditingController();
  final _heightController = TextEditingController();
  bool _isFragile = false;
  bool _requiresRefrigeration = false;
  bool _hazardousMaterial = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    _unitWeightController.dispose();
    _unitVolumeController.dispose();
    _lengthController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _addItem() {
    if (_formKey.currentState?.validate() ?? false) {
      final item = CargoItemModel(
        name: _nameController.text,
        description: _descriptionController.text,
        quantity: int.parse(_quantityController.text),
        unitWeight: double.parse(_unitWeightController.text),
        unitVolume: double.parse(_unitVolumeController.text),
        length: double.parse(_lengthController.text),
        width: double.parse(_widthController.text),
        height: double.parse(_heightController.text),
        isFragile: _isFragile,
        requiresRefrigeration: _requiresRefrigeration,
        hazardousMaterial: _hazardousMaterial,
      );

      widget.onAddItem(item);
      _clearForm();
    }
  }

  void _clearForm() {
    _nameController.clear();
    _descriptionController.clear();
    _quantityController.clear();
    _unitWeightController.clear();
    _unitVolumeController.clear();
    _lengthController.clear();
    _widthController.clear();
    _heightController.clear();
    setState(() {
      _isFragile = false;
      _requiresRefrigeration = false;
      _hazardousMaterial = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Itens da Carga',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: _nameController,
                label: 'Nome do Item',
                hint: 'Digite o nome do item',
                validator: widget.validator,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _descriptionController,
                label: 'Descrição',
                hint: 'Digite a descrição do item',
                maxLines: 3,
                validator: widget.validator,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _quantityController,
                label: 'Quantidade',
                hint: 'Digite a quantidade',
                keyboardType: TextInputType.number,
                validator: widget.numberValidator,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _unitWeightController,
                label: 'Peso Unitário (kg)',
                hint: 'Digite o peso unitário',
                keyboardType: TextInputType.number,
                validator: widget.numberValidator,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _unitVolumeController,
                label: 'Volume Unitário (m³)',
                hint: 'Digite o volume unitário',
                keyboardType: TextInputType.number,
                validator: widget.numberValidator,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _lengthController,
                      label: 'Comprimento (cm)',
                      hint: 'Digite o comprimento',
                      keyboardType: TextInputType.number,
                      validator: widget.numberValidator,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      controller: _widthController,
                      label: 'Largura (cm)',
                      hint: 'Digite a largura',
                      keyboardType: TextInputType.number,
                      validator: widget.numberValidator,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      controller: _heightController,
                      label: 'Altura (cm)',
                      hint: 'Digite a altura',
                      keyboardType: TextInputType.number,
                      validator: widget.numberValidator,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Frágil'),
                value: _isFragile,
                onChanged: (value) {
                  setState(() {
                    _isFragile = value ?? false;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Requer Refrigeração'),
                value: _requiresRefrigeration,
                onChanged: (value) {
                  setState(() {
                    _requiresRefrigeration = value ?? false;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Material Perigoso'),
                value: _hazardousMaterial,
                onChanged: (value) {
                  setState(() {
                    _hazardousMaterial = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _addItem,
                  child: const Text('Adicionar Item'),
                ),
              ),
            ],
          ),
        ),
        if (widget.items.isNotEmpty) ...[
          const SizedBox(height: 24),
          const Text(
            'Itens Adicionados',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              final item = widget.items[index];
              return Card(
                child: ListTile(
                  title: Text(item.name),
                  subtitle: Text(item.description),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => widget.onRemoveItem(index),
                  ),
                ),
              );
            },
          ),
        ],
      ],
    );
  }
}
