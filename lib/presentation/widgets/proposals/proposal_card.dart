import 'package:flutter/material.dart';
import 'package:levvu_client/core/constants/app_colors.dart';

class ProposalCard extends StatelessWidget {
  final Map<String, dynamic> proposal;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback onViewDetails;

  const ProposalCard({
    super.key,
    required this.proposal,
    required this.onAccept,
    required this.onReject,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabeçalho com informações do parceiro
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                // Avatar do parceiro
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primary.withOpacity(0.2),
                  child: Icon(
                    Icons.local_shipping_outlined,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                // Informações do parceiro
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        proposal['parceiro'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${proposal['avaliacao']} (${proposal['totalEntregas']} entregas)',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Valor da proposta
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      proposal['valor'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Proposta #${proposal['id']}',
                      style: TextStyle(
                        color: AppColors.textLight,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Detalhes da proposta
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Prazo e distância
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoItem(
                        Icons.access_time,
                        'Prazo estimado',
                        proposal['prazoEstimado'],
                      ),
                    ),
                    Expanded(
                      child: _buildInfoItem(
                        Icons.directions_car,
                        'Distância',
                        proposal['distancia'],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Observações
                _buildInfoItem(
                  Icons.comment_outlined,
                  'Observações do parceiro',
                  proposal['observacoes'],
                ),
                const SizedBox(height: 16),

                // Data e hora
                _buildInfoItem(
                  Icons.calendar_today_outlined,
                  'Data e hora da proposta',
                  proposal['dataHora'],
                ),
                const SizedBox(height: 16),

                // Botões de ação
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onReject,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('RECUSAR'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onAccept,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('ACEITAR'),
                      ),
                    ),
                  ],
                ),

                // Botão para ver mais detalhes
                Center(
                  child: TextButton.icon(
                    onPressed: onViewDetails,
                    icon: Icon(
                      Icons.info_outline,
                      color: AppColors.primary,
                      size: 16,
                    ),
                    label: Text(
                      'Ver mais detalhes',
                      style: TextStyle(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
