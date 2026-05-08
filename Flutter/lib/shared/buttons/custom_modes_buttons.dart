import 'package:flutter/material.dart';
import 'package:mini_robo/shared/texts/custom_text.dart';

class CustomModesButtons extends StatefulWidget {
  final String text;
  const CustomModesButtons({super.key, required this.text});

  @override
  State<CustomModesButtons> createState() => _CustomModesButtonsState();
}

class _CustomModesButtonsState extends State<CustomModesButtons> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 372,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
        gradient: LinearGradient(
          colors: [
            Colors.black.withValues(alpha: 0.5),
            Colors.black.withValues(alpha: 0.2),
            Colors.black.withValues(alpha: 0.2),
            Colors.black.withValues(alpha: 0.1),
            Colors.black.withValues(alpha: 0.1),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CustomText(
                  text: widget.text,
                  fontSize: 29,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
