import 'package:flutter/material.dart';
import 'package:levvu_client/core/constants/app_colors.dart';

class AcompanhamentoFretePage extends StatefulWidget {
  const AcompanhamentoFretePage({super.key});

  @override
  State<AcompanhamentoFretePage> createState() => _AcompanhamentoFretePageState();
}

class _AcompanhamentoFretePageState extends State<AcompanhamentoFretePage> {
  // Dados simulados do frete em andamento
  final Map<String, dynamic> _frete = {
    'id': '3001',
    'status': 'Em andamento',
    'etapaAtual': 'A caminho do destino',
    'origem': 'Av. Paulista, 1000 - São Paulo, SP',
    'destino': 'Rua Augusta, 500 - São Paulo, SP',
    'dataHora': '22/05/2025 - 14:30',
    'tipo': 'Pequeno',
    'valor': 'R\$ 120,00',
    'parceiro': {
      'nome': 'Transportes Rápidos',
      'avaliacao': 4.8,
      'telefone': '(11) 98765-4321',
      'placa': 'ABC-1234',
      'modelo': 'Fiat Fiorino',
      'cor': 'Branco',
    },
    'etapas': [
      {
        'titulo': 'Solicitação enviada',
        'descricao': 'Sua solicitação de frete foi enviada com sucesso',
        'horario': '14:00',
        'concluida': true,
      },
      {
        'titulo': 'Proposta aceita',
        'descricao': 'Você aceitou a proposta de Transportes Rápidos',
        'horario': '14:10',
        'concluida': true,
      },
      {
        'titulo': 'Parceiro a caminho',
        'descricao': 'O parceiro está a caminho do local de retirada',
        'horario': '14:15',
        'concluida': true,
      },
      {
        'titulo': 'Retirada realizada',
        'descricao': 'O parceiro retirou os itens no local de origem',
        'horario': '14:25',
        'concluida': true,
      },
      {
        'titulo': 'Em trânsito',
        'descricao': 'Seus itens estão a caminho do destino',
        'horario': '14:30',
        'concluida': true,
        'atual': true,
      },
      {
        'titulo': 'Entrega realizada',
        'descricao': 'Seus itens foram entregues no destino',
        'horario': 'Previsto: 15:00',
        'concluida': false,
      },
      {
        'titulo': 'Frete concluído',
        'descricao': 'Frete finalizado com sucesso',
        'horario': 'Previsto: 15:05',
        'concluida': false,
      },
    ],
    'tempoRestante': '30 minutos',
    'distanciaRestante': '2,5 km',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acompanhamento de Frete'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              // Implementar ajuda/suporte
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho com status
            _buildStatusHeader(),
            
            // Mapa (placeholder)
            _buildMapPlaceholder(),
            
            // Informações do frete
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Detalhes do frete
                  _buildFreteDetails(),
                  
                  const SizedBox(height: 24),
                  
                  // Informações do parceiro
                  _buildParceiroInfo(),
                  
                  const SizedBox(height: 24),
                  
                  // Timeline de etapas
                  _buildTimelineEtapas(),
                  
                  const SizedBox(height: 24),
                  
                  // Botões de ação
                  _buildActionButtons(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusHeader() {
    return Container(
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
                'Frete #${_frete['id']}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  _frete['status'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _frete['etapaAtual'],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tempo estimado: ${_frete['tempoRestante']} • Distância: ${_frete['distanciaRestante']}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPlaceholder() {
    return Container(
      height: 200,
      width: double.infinity,
      color: Colors.grey[200],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.map,
              size: 48,
              color: AppColors.primary,
            ),
            const SizedBox(height: 8),
            Text(
              'Mapa de Acompanhamento',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Aqui seria exibido o mapa com a localização em tempo real',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFreteDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detalhes do Frete',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        _buildInfoRow(
          Icons.location_on_outlined,
          'Origem:',
          _frete['origem'],
        ),
        const SizedBox(height: 8),
        _buildInfoRow(
          Icons.flag_outlined,
          'Destino:',
          _frete['destino'],
        ),
        const SizedBox(height: 8),
        _buildInfoRow(
          Icons.calendar_today_outlined,
          'Data e Hora:',
          _frete['dataHora'],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildInfoRow(
                Icons.local_shipping_outlined,
                'Tipo:',
                _frete['tipo'],
              ),
            ),
            Expanded(
              child: _buildInfoRow(
                Icons.attach_money_outlined,
                'Valor:',
                _frete['valor'],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildParceiroInfo() {
    final parceiro = _frete['parceiro'];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informações do Parceiro',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Container(
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
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: Icon(
                      Icons.person,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          parceiro['nome'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.textPrimary,
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
                              '${parceiro['avaliacao']}',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.phone,
                      color: AppColors.primary,
                    ),
                    onPressed: () {
                      // Implementar chamada telefônica
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.message,
                      color: AppColors.primary,
                    ),
                    onPressed: () {
                      // Implementar chat
                    },
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Veículo',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${parceiro['modelo']} - ${parceiro['cor']}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Placa',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          parceiro['placa'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineEtapas() {
    final etapas = _frete['etapas'];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Progresso do Frete',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: etapas.length,
          itemBuilder: (context, index) {
            final etapa = etapas[index];
            final isLast = index == etapas.length - 1;
            
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: etapa['concluida']
                            ? AppColors.primary
                            : Colors.grey[300],
                        shape: BoxShape.circle,
                        border: etapa['atual'] == true
                            ? Border.all(color: AppColors.primary, width: 2)
                            : null,
                      ),
                      child: etapa['concluida']
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            )
                          : null,
                    ),
                    if (!isLast)
                      Container(
                        width: 2,
                        height: 40,
                        color: etapa['concluida']
                            ? AppColors.primary
                            : Colors.grey[300],
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        etapa['titulo'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: etapa['concluida']
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        etapa['descricao'],
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        etapa['horario'],
                        style: TextStyle(
                          color: etapa['atual'] == true
                              ? AppColors.primary
                              : AppColors.textLight,
                          fontSize: 12,
                          fontWeight: etapa['atual'] == true
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: isLast ? 0 : 16),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            // Implementar chat com o parceiro
          },
          icon: const Icon(Icons.message),
          label: const Text('ENVIAR MENSAGEM'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () {
            // Implementar cancelamento
            _showCancelDialog();
          },
          icon: const Icon(Icons.cancel_outlined),
          label: const Text('CANCELAR FRETE'),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
            side: const BorderSide(color: Colors.red),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
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

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar Frete'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Você está prestes a cancelar o frete em andamento. Esta ação não pode ser desfeita.',
              style: TextStyle(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),
            const Text(
              'Motivo do cancelamento:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Informe o motivo do cancelamento...',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Nota: Cancelamentos podem estar sujeitos a taxas conforme os termos de serviço.',
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('VOLTAR'),
          ),
          ElevatedButton(
            onPressed: () {
              // Implementar lógica de cancelamento
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Frete cancelado com sucesso'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('CONFIRMAR CANCELAMENTO'),
          ),
        ],
      ),
    );
  }
}
