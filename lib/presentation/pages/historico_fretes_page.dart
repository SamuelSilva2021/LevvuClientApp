import 'package:flutter/material.dart';
import 'package:levvu_client/core/constants/app_colors.dart';
import 'package:levvu_client/core/models/freight_request_response_model.dart';
import 'package:levvu_client/core/services/api/api_service.dart';

class HistoricoFretesPage extends StatefulWidget {
  const HistoricoFretesPage({super.key});

  @override
  State<HistoricoFretesPage> createState() => _HistoricoFretesPageState();
}

class _HistoricoFretesPageState extends State<HistoricoFretesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<FreightRequestResponse> _freights = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadFreights();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uiFretes = _convertToUiFormat(_freights);
    final fretesPendentes = uiFretes.where((f) => f['status'] == 'Draft' 
    || f['status'] == 'Pending'
    || f['status'] == 'Approved'
    || f['status'] == 'Collecting'
    || f['status'] == 'InTransit'
    || f['status'] == 'AwaitingPayment'
    ).toList();
    final fretesConcluidos = uiFretes.where((f) => f['status'] == 'Delivered'
    || f['status'] == 'Completed'
    ).toList();

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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : RefreshIndicator(
                  onRefresh: _loadFreights,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Aba Todos
                      _buildFretesList(uiFretes),

                      // Aba Em andamento
                      fretesPendentes.isEmpty
                          ? _buildEmptyState(
                              'Nenhum frete em andamento',
                              'Suas solicitações em andamento aparecerão aqui',
                            )
                          : _buildFretesList(fretesPendentes),

                      // Aba Concluídos
                      fretesConcluidos.isEmpty
                          ? _buildEmptyState(
                              'Nenhum frete concluído',
                              'Seu histórico de fretes concluídos aparecerá aqui',
                            )
                          : _buildFretesList(fretesConcluidos),
                    ],
                  ),
                ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
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
            title,
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFretesList(List<Map<String, dynamic>> fretes) {
    return ListView.builder(
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
                        icon: const Icon(Icons.visibility_outlined, size: 18),
                        label: const Text('DETALHES'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: BorderSide(color: AppColors.primary),
                          maximumSize: const Size(120, 40),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
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
                            padding: const EdgeInsets.symmetric(horizontal: 8),
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

  Future<void> _loadFreights() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await ApiService().getClientFreights();
      
      if (response.isSuccess && response.data != null) {
        setState(() {
          _freights = response.data!;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = response.message;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Erro de conexão: ${e.toString()}';
      });
    }
  }

  List<Map<String, dynamic>> _convertToUiFormat(List<FreightRequestResponse> fretes) {
    return fretes.map((frete) {
      return {
        'id': frete.id.toString(),
        'origem': frete.pickupAddress,
        'destino': frete.deliveryAddress,
        'data': _formatDate(frete.withdrawalDate.toString()),
        'hora': _formatTime(frete.pickupTime!),
        'tipo': frete.serviceType,
        'status': _mapStatus(frete.status),
        'valor': 'R\$ --,--',
        'parceiro': 'Parceiro não especificado',
        'avaliacao': 5,
      };
    }).toList();
  }

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return 'Data inválida';
    }
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _mapStatus(String apiStatus) {
    switch (apiStatus) {
      case 'Pendente':
        return 'Em andamento';
      case 'Concluído':
        return 'Concluído';
      case 'Cancelado':
        return 'Cancelado';
      default:
        return apiStatus;
    }
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