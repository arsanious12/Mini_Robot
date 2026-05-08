import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mini_robo/core/utils/app_colors.dart';
import 'package:mini_robo/shared/texts/custom_text.dart';

class CustomGlassBox extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color? backColor;
  final Color? fontColor;
  final double? height;
  final double? width;
  final double? fontSize;
  final double? radius;
  final double? iconsize;
  final Color? iconcolor;
  final Function()?ontap;

  const CustomGlassBox({
    super.key,
    required this.text,
    required this.icon,
    this.backColor,
    this.fontColor,
    this.height,
    this.width,
    this.iconcolor,
    this.iconsize,
    this.radius,
    this.fontSize, this.ontap,  
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(21.0, 15, 0.0, 0),
        child: ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(40),
      
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 10),
      
            child: Container(
              padding: EdgeInsets.all(16),
              width: width ?? 145,
              height: height ?? 130,
      
              decoration: BoxDecoration(
                color: backColor ?? Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(radius ?? 40),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1.5,
                ),
      
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
      
              child: Column(
                children: [
                  Icon(
                    icon,
                    size: iconsize ?? 50,
                    color: iconcolor ?? AppColors.icons,
                  ),
                  // Gap(5),
                  CustomText(
                    text: text,
                    fontSize: fontSize ?? 24,
                    fontColor: fontColor ?? AppColors.textColor2,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
