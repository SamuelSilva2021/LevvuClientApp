import 'package:flutter/material.dart';
import 'package:levvu_client/presentation/widgets/freight/photo_upload.dart';

class PhotosStep extends StatelessWidget {
  final List<String> photoUrls;
  final Function(String) onPhotoAdded;
  final Function(int) onPhotoRemoved;

  const PhotosStep({
    super.key,
    required this.photoUrls,
    required this.onPhotoAdded,
    required this.onPhotoRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fotos dos Itens',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Adicione fotos dos itens que serão transportados',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 24),
        PhotoUpload(
          photoUrls: photoUrls,
          onPhotoAdded: onPhotoAdded,
          onPhotoRemoved: onPhotoRemoved,
        ),
      ],
    );
  }
} 