import 'package:flutter/material.dart';
import 'package:levvu_client/core/constants/app_colors.dart';

class PhotoUploadCard extends StatelessWidget {
  final VoidCallback onTap;
  final String? imageUrl;

  const PhotoUploadCard({
    super.key,
    required this.onTap,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                ),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate_outlined,
                      color: AppColors.primary,
                      size: 32,
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Adicionar',
                      style: TextStyle(
                        color: AppColors.textLight,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
