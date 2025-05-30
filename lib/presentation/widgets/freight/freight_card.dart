import 'package:flutter/material.dart';
import 'package:levvu_client/core/constants/app_colors.dart';

class FreightCard extends StatelessWidget {
  final Map<String, dynamic> freight;
  final VoidCallback onViewDetails;
  final VoidCallback? onRepeat;

  const FreightCard({
    super.key,
    required this.freight,
    required this.onViewDetails,
    this.onRepeat,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho com ID e status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Frete #${freight['id']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                _buildStatusChip(freight['status']),
              ],
            ),
            const Divider(),

            // Origem e destino
            _buildInfoRow(
              Icons.location_on_outlined,
              'Origem:',
              freight['origem'],
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              Icons.flag_outlined,
              'Destino:',
              freight['destino'],
            ),
            const SizedBox(height: 8),

            // Data, hora e tipo
            Row(
              children: [
                Expanded(
                  child: _buildInfoRow(
                    Icons.calendar_today_outlined,
                    'Data:',
                    freight['data'],
                  ),
                ),
                Expanded(
                  child: _buildInfoRow(
                    Icons.access_time_outlined,
                    'Hora:',
                    freight['hora'],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              Icons.local_shipping_outlined,
              'Tipo:',
              freight['tipo'],
            ),
            const SizedBox(height: 8),

            // Parceiro e valor
            _buildInfoRow(
              Icons.person_outline,
              'Parceiro:',
              freight['parceiro'],
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              Icons.attach_money_outlined,
              'Valor:',
              freight['valor'],
            ),

            // Avaliação
            if (freight['status'] == 'Concluído') ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.star_outline,
                    size: 20,
                    color: Colors.amber,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Avaliação:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    children: List.generate(
                      5,
                      (i) => Icon(
                        i < freight['avaliacao']
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.amber,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 16),

            // Botões de ação
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 120,
                  height: 40,
                  child: OutlinedButton.icon(
                    onPressed: onViewDetails,
                    icon: const Icon(Icons.visibility_outlined, size: 18),
                    label: const Text('DETALHES'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      maximumSize: const Size(120, 40),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ),
                ),
                if (freight['status'] == 'Concluído' && onRepeat != null) ...[
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 120,
                    height: 40,
                    child: ElevatedButton.icon(
                      onPressed: onRepeat,
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text('REPETIR'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case 'Concluído':
        backgroundColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green;
        break;
      case 'Em andamento':
        backgroundColor = Colors.blue.withOpacity(0.1);
        textColor = Colors.blue;
        break;
      case 'Cancelado':
        backgroundColor = Colors.red.withOpacity(0.1);
        textColor = Colors.red;
        break;
      default:
        backgroundColor = Colors.grey.withOpacity(0.1);
        textColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 28, bottom: 4),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline,
            size: 16,
            color: AppColors.primary,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  String _mapProposalStatus(String status) {
    switch (status) {
      case 'Pending':
        return 'Pendente';
      case 'Accepted':
        return 'Aceita';
      case 'Rejected':
        return 'Rejeitada';
      case 'Cancelled':
        return 'Cancelada';
      default:
        return status;
    }
  }
}
