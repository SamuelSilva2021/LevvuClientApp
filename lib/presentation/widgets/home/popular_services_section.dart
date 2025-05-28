import 'package:flutter/material.dart';
import 'package:levvu_client/core/constants/app_colors.dart';

class PopularServicesSection extends StatelessWidget {
  final List<Map<String, dynamic>> services;
  final VoidCallback onViewAll;

  const PopularServicesSection({
    super.key,
    required this.services,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Serviços Populares', onViewAll),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildServiceCard(services[0]),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildServiceCard(services[1]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, VoidCallback onViewAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: onViewAll,
          child: Text(
            'Ver todos',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: service['color'].withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                service['icon'],
                color: service['color'],
                size: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              service['title'],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 