import 'package:flutter/material.dart';
import 'package:levvu_client/core/constants/app_colors.dart';
import 'package:levvu_client/core/constants/app_strings.dart';
import 'package:levvu_client/core/constants/asset_constants.dart';

class LogoHeader extends StatelessWidget {
  const LogoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.asset(
              AssetConstants.logo,
              width: 100,
              height: 100,
              fit: BoxFit.contain,
              colorBlendMode: BlendMode.srcOver,
            ),
          ),
          const SizedBox(height: 24),         
          const SizedBox(height: 8),
          Text(
            AppStrings.appSubtitle,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
