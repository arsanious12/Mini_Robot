import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:mini_robo/core/utils/app_colors.dart';
import 'package:mini_robo/features/camera_screens/widgets/main_camera_screen.dart';
import 'package:mini_robo/features/home/widgets/home_screen.dart';
import 'package:mini_robo/features/information/widgets/information_screen.dart';
import 'package:mini_robo/features/movement/widgets/movement_screen.dart';

class BottomNavigationCustom extends StatefulWidget {
  const BottomNavigationCustom({super.key});

  @override
  State<BottomNavigationCustom> createState() => _BottomNavigationCustomState();
}

class _BottomNavigationCustomState extends State<BottomNavigationCustom> {
  final List<Widget> pages = [
    const Home(),
    const Movement(),
    const Information(),
    const Camera(),
  ];

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final double sw = MediaQuery.of(context).size.width;
    final double sh = MediaQuery.of(context).size.height;
    return Scaffold(
      body: pages[currentPage],
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: sw * 0.03,
            vertical: sh * 0.02,
          ),
          child: Container(
            width: sw * 0.05,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(
                    155,
                    0,
                    0,
                    0,
                  ).withValues(alpha: .2),
                  blurRadius: 100,
                  spreadRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryColor.withValues(alpha: 0.5),
                  AppColors.primaryColor.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(30),
            ),

            child: GNav(
              selectedIndex: currentPage,
              onTabChange: (value) => setState(() {
                currentPage = value;
              }),
              textStyle: TextStyle(
                fontSize: 14,
                fontFamily: 'inter',
                fontWeight: FontWeight.w900,
              ),
              backgroundColor: Colors.transparent,
              color: AppColors.primaryColor,
              activeColor: AppColors.textColor,
              iconSize: 20,
              tabBackgroundGradient: LinearGradient(
                colors: [
                  AppColors.primaryColor.withValues(alpha: 0.5),
                  AppColors.primaryColor.withValues(alpha: 0),
                ],
              ),
              gap: 5,
              tabs: [
                GButton(icon: Icons.smart_toy, text: 'Robot'),
                GButton(icon: Icons.control_camera, text: 'Moving'),
                GButton(icon: Icons.my_library_books_rounded, text: 'Info'),
                GButton(icon: Icons.camera, text: 'Camera'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
