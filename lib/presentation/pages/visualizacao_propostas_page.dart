import 'package:flutter/material.dart';
import 'package:levvu_client/core/constants/app_colors.dart';

class VisualizacaoPropostasPage extends StatefulWidget {
  const VisualizacaoPropostasPage({super.key});

  @override
  State<VisualizacaoPropostasPage> createState() => _VisualizacaoPropostasPageState();
}

class _VisualizacaoPropostasPageState extends State<VisualizacaoPropostasPage> {
  // Lista de propostas simuladas para demonstração
  final List<Map<String, dynamic>> _propostas = [
    {
      'id': '2001',
      'parceiro': 'Transportes Rápidos',
      'avaliacao': 4.8,
      'totalEntregas': 1250,
      'valor': 'R\$ 120,00',
      'prazoEstimado': '1 hora',
      'distancia': '5,2 km',
      'observacoes': 'Veículo com ar-condicionado. Disponível para ajudar no carregamento.',
      'status': 'Pendente',
      'dataHora': '22/05/2025 - 10:30',
      'fotoVeiculo': '',
      'fotoMotorista': '',
    },
    {
      'id': '2002',
      'parceiro': 'Entregas Seguras',
      'avaliacao': 4.5,
      'totalEntregas': 980,
      'valor': 'R\$ 135,00',
      'prazoEstimado': '45 minutos',
      'distancia': '4,8 km',
      'observacoes': 'Veículo com baú. Proteção extra para itens frágeis.',
      'status': 'Pendente',
      'dataHora': '22/05/2025 - 09:45',
      'fotoVeiculo': '',
      'fotoMotorista': '',
    },
    {
      'id': '2003',
      'parceiro': 'Transportes Confiança',
      'avaliacao': 4.2,
      'totalEntregas': 750,
      'valor': 'R\$ 110,00',
      'prazoEstimado': '1 hora e 15 minutos',
      'distancia': '5,5 km',
      'observacoes': 'Motorista experiente. Seguro para todos os itens transportados.',
      'status': 'Pendente',
      'dataHora': '22/05/2025 - 08:15',
      'fotoVeiculo': '',
      'fotoMotorista': '',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Propostas Recebidas'),
      ),
      body: _propostas.isEmpty
          ? _buildEmptyState()
          : _buildPropostasList(),
    );
  }

  Widget _buildEmptyState() {
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
            onPressed: () {
              // Implementar atualização/refresh
            },
            icon: const Icon(Icons.refresh),
            label: const Text('ATUALIZAR'),
          ),
        ],
      ),
    );
  }

  Widget _buildPropostasList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _propostas.length,
      itemBuilder: (context, index) {
        final proposta = _propostas[index];
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
                            proposta['parceiro'],
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
                                '${proposta['avaliacao']} (${proposta['totalEntregas']} entregas)',
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
                          proposta['valor'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Proposta #${proposta['id']}',
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
                            proposta['prazoEstimado'],
                          ),
                        ),
                        Expanded(
                          child: _buildInfoItem(
                            Icons.directions_car,
                            'Distância',
                            proposta['distancia'],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Observações
                    _buildInfoItem(
                      Icons.comment_outlined,
                      'Observações do parceiro',
                      proposta['observacoes'],
                    ),
                    const SizedBox(height: 16),
                    
                    // Data e hora
                    _buildInfoItem(
                      Icons.calendar_today_outlined,
                      'Data e hora da proposta',
                      proposta['dataHora'],
                    ),
                    const SizedBox(height: 16),
                    
                    // Botões de ação
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              // Implementar recusa de proposta
                              _showRecusarPropostaDialog(proposta);
                            },
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
                            onPressed: () {
                              // Implementar aceitação de proposta
                              _showAceitarPropostaDialog(proposta);
                            },
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
                        onPressed: () {
                          // Implementar visualização detalhada
                        },
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
      },
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

  void _showRecusarPropostaDialog(Map<String, dynamic> proposta) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Recusar Proposta'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Você está prestes a recusar a proposta de ${proposta['parceiro']} no valor de ${proposta['valor']}.',
              style: TextStyle(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),
            const Text(
              'Motivo da recusa (opcional):',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Informe o motivo da recusa...',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CANCELAR'),
          ),
          ElevatedButton(
            onPressed: () {
              // Implementar lógica de recusa
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Proposta recusada com sucesso'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('RECUSAR'),
          ),
        ],
      ),
    );
  }

  void _showAceitarPropostaDialog(Map<String, dynamic> proposta) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Aceitar Proposta'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Você está prestes a aceitar a proposta de ${proposta['parceiro']} no valor de ${proposta['valor']}.',
              style: TextStyle(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),
            Text(
              'Ao aceitar esta proposta, você concorda com os termos de serviço e será cobrado o valor de ${proposta['valor']} após a conclusão do frete.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CANCELAR'),
          ),
          ElevatedButton(
            onPressed: () {
              // Implementar lógica de aceitação
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Proposta aceita com sucesso'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('ACEITAR'),
          ),
        ],
      ),
    );
  }
}
