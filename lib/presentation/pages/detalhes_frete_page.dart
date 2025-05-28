import 'package:flutter/material.dart';
import 'package:levvu_client/core/constants/app_colors.dart';

class DetalhesFretePage extends StatelessWidget {
  final Map<String, dynamic> freight;

  const DetalhesFretePage({
    super.key,
    required this.freight,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Frete #${freight['id']}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho com status
            Container(
              padding: const EdgeInsets.all(16),
              color: AppColors.primary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.local_shipping,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Frete #${freight['id']}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          freight['status'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Conteúdo principal
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Informações básicas
                  _buildSectionTitle('Informações Básicas'),
                  const SizedBox(height: 16),
                  _buildInfoCard([
                    _buildInfoRow(
                      Icons.location_on_outlined,
                      'Origem:',
                      freight['origem'],
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.flag_outlined,
                      'Destino:',
                      freight['destino'],
                    ),
                    const SizedBox(height: 12),
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
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.local_shipping_outlined,
                      'Tipo:',
                      freight['tipo'],
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // Informações do parceiro
                  _buildSectionTitle('Informações do Parceiro'),
                  const SizedBox(height: 16),
                  _buildInfoCard([
                    _buildInfoRow(
                      Icons.person_outline,
                      'Parceiro:',
                      freight['parceiro'],
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.attach_money_outlined,
                      'Valor:',
                      freight['valor'],
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.description_outlined,
                      'Status da Proposta:',
                      freight['statusProposta'],
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // Descrição e serviços
                  if (freight['descricao']?.isNotEmpty ?? false) ...[
                    _buildSectionTitle('Descrição do Item'),
                    const SizedBox(height: 16),
                    _buildInfoCard([
                      Text(
                        freight['descricao'],
                        style: TextStyle(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ]),
                    const SizedBox(height: 24),
                  ],

                  // Serviços adicionais
                  if ((freight['ajudaCarregamento'] ?? false) ||
                      (freight['desmontagem'] ?? false) ||
                      (freight['embalagemEspecial'] ?? false)) ...[
                    _buildSectionTitle('Serviços Adicionais'),
                    const SizedBox(height: 16),
                    _buildInfoCard([
                      if (freight['ajudaCarregamento'] ?? false)
                        _buildServiceItem('Ajuda no carregamento'),
                      if (freight['desmontagem'] ?? false)
                        _buildServiceItem('Desmontagem/Montagem'),
                      if (freight['embalagemEspecial'] ?? false)
                        _buildServiceItem('Embalagem especial'),
                    ]),
                    const SizedBox(height: 24),
                  ],

                  // Observações
                  if (freight['observacoes']?.isNotEmpty ?? false) ...[
                    _buildSectionTitle('Observações'),
                    const SizedBox(height: 16),
                    _buildInfoCard([
                      Text(
                        freight['observacoes'],
                        style: TextStyle(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ]),
                    const SizedBox(height: 24),
                  ],

                  // Fotos
                  if ((freight['fotos'] as List).isNotEmpty) ...[
                    _buildSectionTitle('Fotos'),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: freight['fotos'].length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                freight['fotos'][index],
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 120,
                                    height: 120,
                                    color: Colors.grey[200],
                                    child: const Icon(
                                      Icons.error_outline,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],

                  // Avaliação
                  if (freight['status'] == 'Concluído') ...[
                    const SizedBox(height: 24),
                    _buildSectionTitle('Avaliação'),
                    const SizedBox(height: 16),
                    _buildInfoCard([
                      Row(
                        children: [
                          const Icon(
                            Icons.star_outline,
                            size: 24,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 8),
                          Text(
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
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
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
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 20,
            color: AppColors.primary,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
