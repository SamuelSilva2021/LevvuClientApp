import 'package:flutter/material.dart';
import 'package:levvu_client/core/constants/app_colors.dart';
import 'package:levvu_client/presentation/widgets/proposals/proposal_card.dart';
import 'package:levvu_client/presentation/widgets/proposals/empty_proposals.dart';
import 'package:levvu_client/presentation/widgets/proposals/proposal_dialogs.dart';

class VisualizacaoPropostasPage extends StatefulWidget {
  const VisualizacaoPropostasPage({super.key});

  @override
  State<VisualizacaoPropostasPage> createState() =>
      _VisualizacaoPropostasPageState();
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
      'observacoes':
          'Veículo com ar-condicionado. Disponível para ajudar no carregamento.',
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
      'observacoes':
          'Motorista experiente. Seguro para todos os itens transportados.',
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
          ? EmptyProposals(
              onRefresh: () {
                // Implementar atualização/refresh
              },
            )
          : _buildPropostasList(),
    );
  }

  Widget _buildPropostasList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _propostas.length,
      itemBuilder: (context, index) {
        final proposta = _propostas[index];
        return ProposalCard(
          proposal: proposta,
          onAccept: () => _handleAcceptProposal(proposta),
          onReject: () => _handleRejectProposal(proposta),
          onViewDetails: () {
            // Implementar visualização detalhada
          },
        );
      },
    );
  }

  void _handleAcceptProposal(Map<String, dynamic> proposta) {
    ProposalDialogs.showAcceptDialog(
      context,
      proposta,
      () {
        // Implementar lógica de aceitação
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Proposta aceita com sucesso'),
            backgroundColor: AppColors.success,
          ),
        );
      },
    );
  }

  void _handleRejectProposal(Map<String, dynamic> proposta) {
    ProposalDialogs.showRejectDialog(
      context,
      proposta,
      () {
        // Implementar lógica de recusa
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Proposta recusada com sucesso'),
            backgroundColor: Colors.red,
          ),
        );
      },
    );
  }
}
