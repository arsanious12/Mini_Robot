import 'package:flutter/material.dart';
import 'package:mini_robo/core/utils/app_colors.dart';
import 'package:mini_robo/shared/buttons/custom_navigation_bottom.dart';
import 'package:mini_robo/shared/buttons/custom_button.dart';
import 'package:mini_robo/shared/oval_gradient.dart';

class Start extends StatelessWidget {
  const Start({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            radius: 1.2,
            colors: [
              Color(0xFF86B4E5),
              Color(0xFFB3D1F2),
              Color(0xFFB3D1F2).withValues(alpha: 0.5),
              Color(0xFFB3D1F2).withValues(alpha: 0.1),
              Color(0xFFB3D1F2).withValues(alpha: 0.0),
            ],
            transform: const OvalGradientTransform(0.6, 1),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/robot_happy.png'),
            CustomButton(
              text: 'let’s go',
              fontSize: 32,
              isImage: false,
              fontColor: AppColors.textColor2,
              backColor: AppColors.primaryColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomNavigationCustom(),
                  ),
                );
              },
              width: 310,
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
