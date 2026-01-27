import 'package:flutter/material.dart';
import '../config/colors.dart';

class ImageLoadingPlaceholder extends StatelessWidget {
  final double? height;

  const ImageLoadingPlaceholder({
    super.key,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: AppColors.sageHint,
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.sage),
        ),
      ),
    );
  }
}
