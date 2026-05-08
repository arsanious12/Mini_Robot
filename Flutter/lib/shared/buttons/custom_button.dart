import 'package:flutter/material.dart';
import 'package:mini_robo/core/utils/app_colors.dart';
import 'package:mini_robo/shared/texts/custom_text.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final double fontSize;
  final double width;
  final double height;
  final Color? fontColor;
  final Color? backColor;
  final VoidCallback onTap;
  final bool isActive;
  final bool? isImage;
  final IconData? icon;
  final double? iconsize;
  final Color? iconcolor;
  final bool? forAutomatic;
  final bool? isIcon;
  const CustomButton({
    super.key,
    required this.text,
    required this.fontSize,
    this.backColor,
    required this.width,
    required this.height,
    this.fontColor,
    this.isImage = false,
    required this.onTap,
    this.isActive = false,
    this.icon,
    this.iconsize,
    this.iconcolor,
    this.forAutomatic,
    this.isIcon = false,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color:
            widget.backColor ??
            (widget.isActive
                ? AppColors.primaryColor.withValues(alpha: 0.45)
                : AppColors.primaryColor),

        borderRadius: widget.forAutomatic == true
            ? BorderRadiusGeometry.circular(20)
            : BorderRadiusGeometry.circular(50),
        border: Border.all(
          color: widget.isActive
              ? AppColors.primaryColor.withValues(alpha: 0.45)
              : Colors.white.withValues(alpha: 0.3),
          width: 1.5,
        ),

        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(114, 120, 120, 120).withValues(alpha: 0.2),
            blurRadius: 100,
            offset: Offset(0, 5),
          ),
        ],
      ),

      child: InkWell(
        onTap: widget.onTap,
        borderRadius: widget.forAutomatic == true
            ? BorderRadius.circular(20)
            : BorderRadius.circular(50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              text: widget.text,
              fontSize: widget.fontSize,
              fontColor:
                  widget.fontColor ??
                  (widget.isActive
                      ? AppColors.textColor
                      : AppColors.textColor2),
              fontWeight: FontWeight.bold,
            ),
            widget.isIcon ?? true
                ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                      widget.icon,
                      size: widget.iconsize,
                      color: widget.iconcolor,
                    ),
                )
                : Icon(null),

            widget.isImage ?? true
                ? Image(
                    image: AssetImage("assets/images/Treble Clef.png"),
                    width: 48,
                    fit: BoxFit.contain,
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
