import 'package:flutter/material.dart';
import 'package:levvu_client/core/constants/app_colors.dart';

class HistoricoFretesPage extends StatefulWidget {
  const HistoricoFretesPage({super.key});

  @override
  State<HistoricoFretesPage> createState() => _HistoricoFretesPageState();
}

class _HistoricoFretesPageState extends State<HistoricoFretesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Lista de fretes simulados para demonstração
  final List<Map<String, dynamic>> _fretes = [
    {
      'id': '1001',
      'origem': 'Av. Paulista, 1000 - São Paulo, SP',
      'destino': 'Rua Augusta, 500 - São Paulo, SP',
      'data': '20/05/2025',
      'hora': '14:30',
      'tipo': 'Pequeno',
      'status': 'Concluído',
      'valor': 'R\$ 120,00',
      'parceiro': 'Transportes Rápidos',
      'avaliacao': 5,
    },
    {
      'id': '1002',
      'origem': 'Rua Oscar Freire, 200 - São Paulo, SP',
      'destino': 'Av. Brigadeiro Faria Lima, 1500 - São Paulo, SP',
      'data': '15/05/2025',
      'hora': '10:00',
      'tipo': 'Médio',
      'status': 'Concluído',
      'valor': 'R\$ 180,00',
      'parceiro': 'Entregas Seguras',
      'avaliacao': 4,
    },
    {
      'id': '1003',
      'origem': 'Av. Rebouças, 1200 - São Paulo, SP',
      'destino': 'Rua Teodoro Sampaio, 800 - São Paulo, SP',
      'data': '10/05/2025',
      'hora': '09:15',
      'tipo': 'Grande',
      'status': 'Concluído',
      'valor': 'R\$ 250,00',
      'parceiro': 'Transportes Confiança',
      'avaliacao': 3,
    },
    {
      'id': '1004',
      'origem': 'Av. Paulista, 800 - São Paulo, SP',
      'destino': 'Av. Ibirapuera, 2000 - São Paulo, SP',
      'data': '05/05/2025',
      'hora': '16:45',
      'tipo': 'Pequeno',
      'status': 'Concluído',
      'valor': 'R\$ 110,00',
      'parceiro': 'Transportes Rápidos',
      'avaliacao': 5,
    },
    {
      'id': '1005',
      'origem': 'Rua Haddock Lobo, 400 - São Paulo, SP',
      'destino': 'Av. Angélica, 1800 - São Paulo, SP',
      'data': '01/05/2025',
      'hora': '11:30',
      'tipo': 'Médio',
      'status': 'Concluído',
      'valor': 'R\$ 160,00',
      'parceiro': 'Entregas Seguras',
      'avaliacao': 4,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Fretes'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: AppColors.textSecondary,
          tabs: const [
            Tab(text: 'Todos'),
            Tab(text: 'Em andamento'),
            Tab(text: 'Concluídos'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Aba Todos
          _buildFretesList(_fretes),

          // Aba Em andamento (vazia para demonstração)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.local_shipping_outlined,
                  size: 80,
                  color: AppColors.primary.withOpacity(0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  'Nenhum frete em andamento',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Suas solicitações em andamento aparecerão aqui',
                  style: TextStyle(
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),

          // Aba Concluídos
          _buildFretesList(_fretes),
        ],
      ),
    );
  }

  Widget _buildFretesList(List<Map<String, dynamic>> fretes) {
    return fretes.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.history,
                  size: 80,
                  color: AppColors.primary.withOpacity(0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  'Nenhum frete encontrado',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Seu histórico de fretes aparecerá aqui',
                  style: TextStyle(
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: fretes.length,
            itemBuilder: (context, index) {
              final frete = fretes[index];
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
                            'Frete #${frete['id']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          _buildStatusChip(frete['status']),
                        ],
                      ),
                      const Divider(),

                      // Origem e destino
                      _buildInfoRow(
                        Icons.location_on_outlined,
                        'Origem:',
                        frete['origem'],
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        Icons.flag_outlined,
                        'Destino:',
                        frete['destino'],
                      ),
                      const SizedBox(height: 8),

                      // Data, hora e tipo
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoRow(
                              Icons.calendar_today_outlined,
                              'Data:',
                              frete['data'],
                            ),
                          ),
                          Expanded(
                            child: _buildInfoRow(
                              Icons.access_time_outlined,
                              'Hora:',
                              frete['hora'],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        Icons.local_shipping_outlined,
                        'Tipo:',
                        frete['tipo'],
                      ),
                      const SizedBox(height: 8),

                      // Parceiro e valor
                      _buildInfoRow(
                        Icons.person_outline,
                        'Parceiro:',
                        frete['parceiro'],
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        Icons.attach_money_outlined,
                        'Valor:',
                        frete['valor'],
                      ),

                      // Avaliação
                      if (frete['status'] == 'Concluído') ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.star_outline,
                              size: 20,
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
                                  i < frete['avaliacao']
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
                              onPressed: () {
                                // Implementar visualização detalhada
                              },
                              icon: const Icon(Icons.visibility_outlined,
                                  size: 18),
                              label: const Text('DETALHES'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primary,
                                side: BorderSide(color: AppColors.primary),
                                maximumSize: const Size(120, 40),
                                padding:const EdgeInsets.symmetric(horizontal: 8),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (frete['status'] == 'Concluído')
                            SizedBox(
                              width: 120,
                              height: 40,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  // Implementar solicitação similar
                                },
                                icon: const Icon(Icons.refresh, size: 18),
                                label: const Text('REPETIR'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
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
}
