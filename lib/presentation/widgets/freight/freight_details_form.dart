import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:levvu_client/core/models/freight_request_model.dart';
import 'package:levvu_client/presentation/widgets/custom_text_field.dart';

class FreightDetailsForm extends StatefulWidget {
  final TextEditingController serviceTypeController;
  final TextEditingController descriptionController;
  final TextEditingController cargoTypeController;
  final TextEditingController weightController;
  final TextEditingController volumeController;
  final TextEditingController pickupTimeController;
  final TextEditingController itemDescriptionController;
  final TextEditingController observationsController;
  final String? Function(String?)? validator;
  final String? Function(String?)? numberValidator;
  final Function(VehicleType)? onVehicleTypeChanged;
  final Function(DateTime)? onWithdrawalDateChanged;
  final Function(bool)? onHelpLoadingChanged;
  final Function(bool)? onDisassemblyAssemblyChanged;
  final Function(bool)? onSpecialPackagingChanged;

  const FreightDetailsForm({
    super.key,
    required this.serviceTypeController,
    required this.descriptionController,
    required this.cargoTypeController,
    required this.weightController,
    required this.volumeController,
    required this.pickupTimeController,
    required this.itemDescriptionController,
    required this.observationsController,
    this.validator,
    this.numberValidator,
    this.onVehicleTypeChanged,
    this.onWithdrawalDateChanged,
    this.onHelpLoadingChanged,
    this.onDisassemblyAssemblyChanged,
    this.onSpecialPackagingChanged,
  });

  @override
  State<FreightDetailsForm> createState() => _FreightDetailsFormState();
}

class _FreightDetailsFormState extends State<FreightDetailsForm> {
  VehicleType _selectedVehicleType = VehicleType.van;
  DateTime _selectedDate = DateTime.now();
  bool _helpLoading = false;
  bool _disassemblyAssembly = false;
  bool _specialPackaging = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Detalhes do Frete',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 16),
              _buildVehicleIcon(
                VehicleType.moto,
                'assets/icons/moto_icon.svg',
                'Moto',
              ),
              _buildVehicleIcon(
                VehicleType.car,
                'assets/icons/car_icon.svg',
                'Carro',
              ),
              const SizedBox(width: 16),
              _buildVehicleIcon(
                VehicleType.minivan,
                'assets/icons/mini_van_icon.svg',
                'Carro bau',
              ),
              const SizedBox(width: 16),
              _buildVehicleIcon(
                VehicleType.van,
                'assets/icons/van_icon.svg',
                'Van',
              ),
              const SizedBox(width: 16),
              _buildVehicleIcon(
                VehicleType.pickup,
                'assets/icons/pickup_icon.svg',
                'Pickup',
              ),
              const SizedBox(width: 16),
              _buildVehicleIcon(
                VehicleType.truck,
                'assets/icons/truck_icon.svg',
                'Caminhão',
              ),
              const SizedBox(width: 16),
              _buildVehicleIcon(
                VehicleType.longtruck,
                'assets/icons/log_truck_icon.svg',
                'Veículo longo',
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: widget.serviceTypeController,
          label: 'Tipo de Serviço',
          hint: 'Digite o tipo de serviço',
          validator: widget.validator,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: widget.descriptionController,
          label: 'Descrição',
          hint: 'Digite a descrição do frete',
          maxLines: 3,
          validator: widget.validator,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: widget.cargoTypeController,
          label: 'Tipo de Carga',
          hint: 'Digite o tipo de carga',
          validator: widget.validator,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: widget.weightController,
                label: 'Peso (kg)',
                hint: 'Digite o peso',
                keyboardType: TextInputType.number,
                validator: widget.numberValidator,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomTextField(
                controller: widget.volumeController,
                label: 'Volume (m³)',
                hint: 'Digite o volume',
                keyboardType: TextInputType.number,
                validator: widget.numberValidator,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListTile(
          title: const Text('Data de Retirada'),
          subtitle: Text(
            '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
          ),
          trailing: const Icon(Icons.calendar_today),
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (date != null) {
              setState(() {
                _selectedDate = date;
              });
              widget.onWithdrawalDateChanged?.call(date);
            }
          },
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: widget.pickupTimeController,
          label: 'Horário de Retirada',
          hint: 'Digite o horário de retirada',
          validator: widget.validator,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: widget.itemDescriptionController,
          label: 'Descrição dos Itens',
          hint: 'Digite a descrição dos itens',
          maxLines: 3,
          validator: widget.validator,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: widget.observationsController,
          label: 'Observações',
          hint: 'Digite as observações',
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        const Text(
          'Serviços Adicionais',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        CheckboxListTile(
          title: const Text('Ajuda no Carregamento'),
          value: _helpLoading,
          onChanged: (value) {
            setState(() {
              _helpLoading = value ?? false;
            });
            widget.onHelpLoadingChanged?.call(value ?? false);
          },
        ),
        CheckboxListTile(
          title: const Text('Desmontagem/Montagem'),
          value: _disassemblyAssembly,
          onChanged: (value) {
            setState(() {
              _disassemblyAssembly = value ?? false;
            });
            widget.onDisassemblyAssemblyChanged?.call(value ?? false);
          },
        ),
        CheckboxListTile(
          title: const Text('Embalagem Especial'),
          value: _specialPackaging,
          onChanged: (value) {
            setState(() {
              _specialPackaging = value ?? false;
            });
            widget.onSpecialPackagingChanged?.call(value ?? false);
          },
        ),
      ],
    );
  }

  Widget _buildVehicleIcon(VehicleType type, String iconPath, String label) {
    final bool isSelected = _selectedVehicleType == type;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedVehicleType = type;
        });
        widget.onVehicleTypeChanged?.call(type);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.transparent,
                width: 2,
              ),
            ),
            child: Stack(
              children: [
                SvgPicture.asset(
                  iconPath,
                  width: 50,
                  height: 50,
                  placeholderBuilder: (context) => const Icon(
                    Icons.directions_car,
                    size: 50,
                    color: Colors.grey,
                  ),
                ),
                
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color:
                  isSelected ? Theme.of(context).primaryColor : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
