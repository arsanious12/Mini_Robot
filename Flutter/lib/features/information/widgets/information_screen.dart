import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_robo/core/utils/app_colors.dart';
import 'package:mini_robo/logic/camera/cubit/camera_cubit.dart';
import 'package:mini_robo/shared/buttons/custom_glass_box.dart';
import 'package:mini_robo/shared/texts/custom_title.dart';

class Information extends StatefulWidget {
  const Information({super.key});

  @override
  State<Information> createState() => _InformationState();
}

class _InformationState extends State<Information> {
  @override
  Widget build(BuildContext context) {
    final double sw = MediaQuery.of(context).size.width;
    final double sh = MediaQuery.of(context).size.height; 

    // Data list for your grid items
    final List<Map<String, dynamic>> infoItems = [
      {
        'icon': Icons.phone_iphone,
        'text': 'Flutter',
        'color': AppColors.textColor2,
        'ontap': (){ context.read<CameraCubit>().sendInfo("Flutter"); print('flutterrrr');}
      },
      {
        'icon': Icons.device_hub,
        'text': 'IOT',
        'color': AppColors.primaryColor,
        'iconColor': AppColors.secondaryColor,
         'ontap': (){ context.read<CameraCubit>().sendInfo("IOT");}
      },
      {
        'icon': Icons.auto_awesome,
        'text': 'AI',
        'color': AppColors.primaryColor,
        'iconColor': AppColors.secondaryColor,
         'ontap': (){ context.read<CameraCubit>().sendInfo("AI");}
      },
      {
        'icon': Icons.movie_edit,
        'text': 'Media',
        'color': AppColors.textColor2,
         'ontap': (){ context.read<CameraCubit>().sendInfo("Media");}
      },
      {
        'icon': Icons.control_camera,
        'text': 'ROV',
        'color': AppColors.textColor2,
         'ontap': (){ context.read<CameraCubit>().sendInfo("ROV");}
      },
    ];

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding:  EdgeInsetsGeometry.fromLTRB(
            sw * 0.05,
            sw * 0.15,
            sw * 0.05,
            0,
          ),
              child: Column(
                children: [
                  const CustomTitle(),
                  SizedBox(height: sh * 0.005),

                  // Flexible GridView
                  Expanded(
                    child: GridView.builder(
                      // Standard grid settings
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 2 items per row
                        crossAxisSpacing: sw * 0.04, // Space between columns
                        mainAxisSpacing: sh * 0.02, // Space between rows
                        childAspectRatio: 1.1, // Adjusts the height/width ratio
                      ),
                      itemCount: infoItems.length,
                      padding: EdgeInsets.only(
                        bottom: sh * 0.005,
                      ), // Room for robot image
                      itemBuilder: (context, index) {
                        final item = infoItems[index];
                        return CustomGlassBox(
                          icon: item['icon'],
                          text: item['text'],
                          fontColor: Colors.black,
                          backColor: item['color'],
                          iconsize: sw * 0.2,
                          iconcolor: item['iconColor'],
                          radius: 20,
                          fontSize: sw * 0.04,
                          ontap: item['ontap'],
                          // Note: height/width are often handled by GridView constraints
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Robot Image at bottom right
            Positioned(
              bottom: -10,
              right: 0,
              child: IgnorePointer(
                child: Image(
                  image: const AssetImage('assets/images/robot_learn.png'),
                  width: sw * 0.45,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
