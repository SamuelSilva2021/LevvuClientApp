import 'package:flutter/material.dart';
import 'package:levvu_client/presentation/widgets/custom_text_field.dart';

class AddressPicker extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final Function(String) onAddressSelected;

  const AddressPicker({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.onAddressSelected,
  });

  @override
  State<AddressPicker> createState() => _AddressPickerState();
}

class _AddressPickerState extends State<AddressPicker> {
  final _searchController = TextEditingController();
  final List<String> _suggestions = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchAddress(String query) async {
    if (query.isEmpty) {
      setState(() {
        _suggestions.clear();
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implementar busca de endereços usando API de geocodificação
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _suggestions.addAll([
          'Rua Exemplo 1, 123 - Bairro 1, Cidade 1 - UF',
          'Rua Exemplo 2, 456 - Bairro 2, Cidade 2 - UF',
          'Rua Exemplo 3, 789 - Bairro 3, Cidade 3 - UF',
        ]);
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: _searchController,
          label: 'Buscar Endereço',
          hint: 'Digite o endereço',
          onChanged: _searchAddress,
        ),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ),
        if (_suggestions.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _suggestions.length,
            itemBuilder: (context, index) {
              final suggestion = _suggestions[index];
              return ListTile(
                title: Text(suggestion),
                onTap: () {
                  widget.controller.text = suggestion;
                  widget.onAddressSelected(suggestion);
                  Navigator.pop(context);
                },
              );
            },
          ),
      ],
    );
  }
}
