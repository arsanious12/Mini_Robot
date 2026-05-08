import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mini_robo/core/utils/app_colors.dart';
import 'package:mini_robo/shared/buttons/custom_button.dart';
import 'package:mini_robo/shared/buttons/custom_navigation_bottom.dart';
import 'package:mini_robo/shared/texts/custom_text.dart';
import 'package:mini_robo/shared/texts/custom_title.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

void _answer(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        "feedback submitted, thank you",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
  );
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const BottomNavigationCustom()),
  );
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  @override
  Widget build(BuildContext context) {
    final double sw = MediaQuery.of(context).size.width;
    final double sh = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Padding(
        padding: EdgeInsetsGeometry.fromLTRB(
          sw * 0.05,
          sw * 0.15,
          sw * 0.05,
          0,
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Gap(70),
                CustomTitle(),
                Gap(50),
                CustomText(
                  text: 'Which mode do you \n  want to try today?',
                  fontSize: sw * 0.07,
                  fontWeight: FontWeight.bold,
                ),

                Gap(30),
                Row(
                  children: [
                    CustomButton(
                      text: 'Perfect',
                      fontSize: sw * 0.06,
                      backColor: AppColors.primaryColor,
                      isImage: false,
                      fontColor: AppColors.textColor2,
                      width: sw * 0.9,
                      height: sh * 0.1,
                      isIcon: true,
                      icon: Icons.star_rate,
                      iconsize: sw * 0.1,
                      iconcolor: AppColors.icons,
                      onTap: () => _answer(context),
                    ),
                  ],
                ),
                Gap(30),
                Row(
                  children: [
                    CustomButton(
                      text: 'Good',
                      fontSize: sw * 0.06,
                      backColor: AppColors.primaryColor,
                      isImage: false,
                      fontColor: AppColors.textColor2,
                      width: sw * 0.9,
                      height: sh * 0.1,
                      isIcon: true,
                      icon: Icons.thumb_up,
                      iconsize: sw * 0.1,
                      iconcolor: AppColors.icons,
                      onTap: () => _answer(context),
                    ),
                  ],
                ),
                Gap(30),
                Row(
                  children: [
                    CustomButton(
                      text: 'Need Enhancement',
                      fontSize: sw * 0.06,
                      backColor: AppColors.primaryColor,
                      isImage: false,
                      fontColor: AppColors.textColor2,
                      width: sw * 0.9,
                      height: sh * 0.1,
                      isIcon: true,
                      icon: Icons.settings,
                      iconsize: sw * 0.1,
                      iconcolor: AppColors.icons,
                      onTap: () => _answer(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
