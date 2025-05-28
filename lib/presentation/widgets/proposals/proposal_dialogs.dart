import 'package:flutter/material.dart';
import 'package:levvu_client/core/constants/app_colors.dart';

class ProposalDialogs {
  static Future<void> showAcceptDialog(
    BuildContext context,
    Map<String, dynamic> proposal,
    VoidCallback onAccept,
  ) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Aceitar Proposta'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Você está prestes a aceitar a proposta de ${proposal['parceiro']} no valor de ${proposal['valor']}.',
              style: TextStyle(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),
            Text(
              'Ao aceitar esta proposta, você concorda com os termos de serviço e será cobrado o valor de ${proposal['valor']} após a conclusão do frete.',
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
              Navigator.of(context).pop();
              onAccept();
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

  static Future<void> showRejectDialog(
    BuildContext context,
    Map<String, dynamic> proposal,
    VoidCallback onReject,
  ) {
    final TextEditingController reasonController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Recusar Proposta'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Você está prestes a recusar a proposta de ${proposal['parceiro']} no valor de ${proposal['valor']}.',
              style: TextStyle(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),
            const Text(
              'Motivo da recusa (opcional):',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: reasonController,
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
              Navigator.of(context).pop();
              onReject();
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
}
