import 'package:flutter/material.dart';
import 'package:levvu_client/core/constants/app_colors.dart';

class AvaliacaoServicoPage extends StatefulWidget {
  const AvaliacaoServicoPage({super.key});

  @override
  State<AvaliacaoServicoPage> createState() => _AvaliacaoServicoPageState();
}

class _AvaliacaoServicoPageState extends State<AvaliacaoServicoPage> {
  // Dados simulados do frete concluído
  final Map<String, dynamic> _frete = {
    'id': '4001',
    'parceiro': 'Transportes Rápidos',
    'motorista': 'Carlos Silva',
    'origem': 'Av. Paulista, 1000 - São Paulo, SP',
    'destino': 'Rua Augusta, 500 - São Paulo, SP',
    'dataHora': '22/05/2025 - 15:30',
    'valor': 'R\$ 120,00',
  };

  // Estado da avaliação
  int _avaliacao = 0;
  final _comentarioController = TextEditingController();
  
  // Critérios de avaliação
  final Map<String, int> _criterios = {
    'Pontualidade': 0,
    'Cuidado com os itens': 0,
    'Cordialidade': 0,
    'Limpeza do veículo': 0,
  };

  @override
  void dispose() {
    _comentarioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avaliar Serviço'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabeçalho com informações do frete
              _buildFreteInfo(),
              
              const SizedBox(height: 24),
              
              // Avaliação geral
              _buildAvaliacaoGeral(),
              
              const SizedBox(height: 24),
              
              // Critérios específicos
              _buildCriteriosAvaliacao(),
              
              const SizedBox(height: 24),
              
              // Comentário
              _buildComentario(),
              
              const SizedBox(height: 32),
              
              // Botão de enviar
              ElevatedButton(
                onPressed: _avaliacao > 0 ? _enviarAvaliacao : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  disabledBackgroundColor: Colors.grey[300],
                ),
                child: const Text('ENVIAR AVALIAÇÃO'),
              ),
              
              const SizedBox(height: 16),
              
              // Pular avaliação
              Center(
                child: TextButton(
                  onPressed: () {
                    // Implementar navegação de volta
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Pular avaliação',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFreteInfo() {
    return Container(
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
                      _frete['parceiro'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Motorista: ${_frete['motorista']}',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Concluído',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 24),
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
          Row(
            children: [
              Expanded(
                child: _buildInfoRow(
                  Icons.calendar_today_outlined,
                  'Data:',
                  _frete['dataHora'],
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
      ),
    );
  }

  Widget _buildAvaliacaoGeral() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Como foi sua experiência?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (index) => GestureDetector(
                onTap: () {
                  setState(() {
                    _avaliacao = index + 1;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(
                    index < _avaliacao ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 40,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            _getAvaliacaoText(),
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCriteriosAvaliacao() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Avalie os critérios específicos',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        ..._criterios.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.key,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        _criterios[entry.key] = index + 1;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        index < entry.value ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          );
        }).toList(),
      ],
    );
  }

  Widget _buildComentario() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Deixe um comentário (opcional)',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _comentarioController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Conte-nos mais sobre sua experiência...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: Colors.white,
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

  String _getAvaliacaoText() {
    switch (_avaliacao) {
      case 1:
        return 'Péssimo';
      case 2:
        return 'Ruim';
      case 3:
        return 'Regular';
      case 4:
        return 'Bom';
      case 5:
        return 'Excelente';
      default:
        return 'Toque para avaliar';
    }
  }

  void _enviarAvaliacao() {
    // Aqui seria implementada a lógica para enviar a avaliação
    
    // Exibir mensagem de sucesso
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Avaliação enviada com sucesso!'),
        backgroundColor: AppColors.success,
      ),
    );
    
    // Navegar de volta após envio
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }
}
