import 'package:flutter/material.dart';
import 'package:mini_robo/core/utils/app_colors.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? fontColor;
  final bool isBlack;
  const CustomText({
    super.key,
    required this.text,
    required this.fontSize,
    this.isBlack = true,
    this.fontColor, required FontWeight fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        maxLines: 2,
        
        overflow: TextOverflow.ellipsis,
        textScaler: TextScaler.linear(1.0),
        style: TextStyle(
          fontFamily: 'inter',
          fontWeight: FontWeight.w900,
          fontSize: fontSize,
          color: fontColor ?? AppColors.textColor,
        ),
      ),
    );
  }
}
