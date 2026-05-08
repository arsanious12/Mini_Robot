import 'package:flutter/material.dart';
import 'package:mini_robo/core/utils/app_colors.dart';

class CustomTitle extends StatelessWidget {
  const CustomTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Mini Robot",
      style: TextStyle(
        fontFamily: 'inter',
        fontWeight: FontWeight.w900,
        fontSize: 54,
        color: AppColors.primaryColor,
        shadows: [
          Shadow(
            color: Color.fromARGB(106, 183, 183, 183),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
    );
  }
}
