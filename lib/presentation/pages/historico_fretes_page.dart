import 'package:flutter/material.dart';
import 'package:levvu_client/core/constants/app_colors.dart';
import 'package:levvu_client/core/models/freight_request_response_model.dart';
import 'package:levvu_client/core/services/api/api_service.dart';
import 'package:levvu_client/presentation/widgets/freight/freight_card.dart';
import 'package:levvu_client/presentation/widgets/freight/empty_freights.dart';
import 'package:levvu_client/presentation/pages/detalhes_frete_page.dart';

class HistoricoFretesPage extends StatefulWidget {
  final int initialTabIndex;

  const HistoricoFretesPage({
    super.key,
    this.initialTabIndex = 0,
  });

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
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
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
    final fretesPendentes = uiFretes
        .where((f) =>
            f['status'] == 'Draft' ||
            f['status'] == 'Pending' ||
            f['status'] == 'Approved' ||
            f['status'] == 'Collecting' ||
            f['status'] == 'InTransit' ||
            f['status'] == 'AwaitingPayment')
        .toList();
    final fretesConcluidos = uiFretes
        .where((f) => f['status'] == 'Delivered' || f['status'] == 'Completed')
        .toList();

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
                          ? const EmptyFreights(
                              title: 'Nenhum frete em andamento',
                              subtitle:
                                  'Suas solicitações em andamento aparecerão aqui',
                            )
                          : _buildFretesList(fretesPendentes),

                      // Aba Concluídos
                      fretesConcluidos.isEmpty
                          ? const EmptyFreights(
                              title: 'Nenhum frete concluído',
                              subtitle:
                                  'Seu histórico de fretes concluídos aparecerá aqui',
                            )
                          : _buildFretesList(fretesConcluidos),
                    ],
                  ),
                ),
    );
  }

  Widget _buildFretesList(List<Map<String, dynamic>> fretes) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: fretes.length,
      itemBuilder: (context, index) {
        final frete = fretes[index];
        return FreightCard(
          freight: frete,
          onViewDetails: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetalhesFretePage(freight: frete),
              ),
            );
          },
          onRepeat: frete['status'] == 'Concluído'
              ? () {
                  // Implementar solicitação similar
                }
              : null,
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

  List<Map<String, dynamic>> _convertToUiFormat(
      List<FreightRequestResponse> fretes) {
    return fretes.map((frete) {
      return {
        'id': frete.id.toString(),
        'origem': frete.pickupAddress,
        'destino': frete.deliveryAddress,
        'data': _formatDate(frete.withdrawalDate.toString()),
        'hora':
            frete.pickupTime != null ? _formatTime(frete.pickupTime!) : '--:--',
        'tipo': frete.serviceType,
        'status': _mapStatus(frete.status),
        'valor': frete.agreedValueFormatted,
        'parceiro': frete.partnerId != null
            ? 'Parceiro #${frete.partnerId}'
            : 'Parceiro não especificado',
        'avaliacao': 5,
        'descricao': frete.itemDescription ?? '',
        'ajudaCarregamento': frete.helpLoading ?? false,
        'desmontagem': frete.disassemblyAssembly ?? false,
        'embalagemEspecial': frete.specialPackaging ?? false,
        'observacoes': frete.observations ?? '',
        'fotos': frete.photoUrls ?? [],
        'statusProposta': frete.proposalStatus,
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
}
