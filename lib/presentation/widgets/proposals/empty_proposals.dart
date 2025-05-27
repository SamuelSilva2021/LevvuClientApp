import 'package:flutter/material.dart';
import 'package:levvu_client/core/constants/app_colors.dart';

class EmptyProposals extends StatelessWidget {
  final VoidCallback onRefresh;

  const EmptyProposals({
    super.key,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.description_outlined,
            size: 80,
            color: AppColors.primary.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhuma proposta recebida',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'As propostas dos parceiros aparecerão aqui',
            style: TextStyle(
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onRefresh,
            icon: const Icon(Icons.refresh),
            label: const Text('ATUALIZAR'),
          ),
        ],
      ),
    );
  }
}
