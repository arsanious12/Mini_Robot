import 'package:flutter/material.dart';
import 'package:mini_robo/core/utils/app_colors.dart';
import 'package:mini_robo/shared/texts/custom_text.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    this.hintText = '',
  });

  final TextEditingController controller;
  final String hintText;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  String? errorText;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 70,
          width: double.infinity,

          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),

          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: errorText == null
                  ? [
                      Colors.black.withValues(alpha: 0.5),
                      Colors.black.withValues(alpha: 0.2),
                      Colors.black.withValues(alpha: 0.2),
                      Colors.black.withValues(alpha: 0.1),
                      Colors.black.withValues(alpha: 0.1),
                    ]
                  : [
                      Colors.red.withValues(alpha: 0.5),
                      Colors.red.withValues(alpha: 0.2),
                      Colors.red.withValues(alpha: 0.2),
                      Colors.red.withValues(alpha: 0.1),
                      Colors.red.withValues(alpha: 0.1),
                    ],
            ),
            borderRadius: BorderRadius.circular(50),
          ),

          child: Container(
            margin: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
            ),

            child: Center(
              child: TextFormField(
                controller: widget.controller,

                cursorColor: AppColors.primaryColor,

                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  color: AppColors.textColor,
                ),

                validator: (v) {
                  if (v == null || v.isEmpty) {
                    setState(() {
                      errorText = "Please enter some text";
                    });
                    return "";
                  }
                  setState(() {
                    errorText = null;
                  });
                  return null;
                },

                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 20,
                  ),

                  fillColor: Colors.transparent,
                  filled: true,

                  enabled: true,

                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  errorStyle: const TextStyle(height: 0, fontSize: 0),
                ),
              ),
            ),
          ),
        ),

        if (errorText != null)
          Positioned(
            bottom: -22,
            left: 30,
            child: CustomText(
              text: errorText!,
              fontSize: 18,
              fontColor: Colors.red, fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }
}
