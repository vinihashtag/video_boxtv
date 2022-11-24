import 'package:flutter/material.dart';

import '../theme/color_theme.dart';

class CustomLoading extends StatelessWidget {
  final Color? color;
  const CustomLoading({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(color ?? AppColors.primary),
    ));
  }
}
