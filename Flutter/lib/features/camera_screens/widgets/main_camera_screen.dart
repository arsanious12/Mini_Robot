import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_robo/core/networking/api_constants.dart';
import 'package:mini_robo/core/networking/http_service.dart';
import 'package:mini_robo/logic/camera/data/repos/camera_repo.dart';
import 'package:mini_robo/logic/camera/cubit/camera_cubit.dart';
import 'package:mini_robo/features/camera_screens/widgets/camera_file.dart';
import 'package:mini_robo/features/camera_screens/widgets/camera_modes_screen.dart';
import 'package:mini_robo/shared/buttons/custom_button.dart';
import 'package:mini_robo/shared/texts/custom_text.dart';
import 'package:mini_robo/shared/texts/custom_title.dart';

class Camera extends StatefulWidget {
  const Camera({super.key});

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  @override
  Widget build(BuildContext context) {
    final double sw = MediaQuery.of(context).size.width;
    final double sh = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Icon(null),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.transparent),
            onPressed: () => _showIPSettingsDialog(context),
          ),
          SizedBox(width: sw * 0.03),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: sw * 0.05),
          child: Column(
            children: [
              const CustomTitle(),

              // Spacer spreads elements out evenly based on screen height
              const Spacer(flex: 2),

              CustomText(
                text: 'Would you like to make',
                fontSize: sw * 0.060, // Responsive font
                fontWeight: FontWeight.bold,
              ),
              CustomText(
                text: 'mini robot remember you?',
                fontSize: sw * 0.060, // Responsive font
                fontWeight: FontWeight.bold,
              ),

              const Spacer(flex: 1),

              CustomButton(
                text: "Yes, let's do it",
                fontSize: sw * 0.08,
                width: sw * 0.9, // 90% of screen width
                height: sh * 0.1, // 10% of screen height
                fontColor: const Color(0xffEBEBEB),
                onTap: () {
                  context.read<CameraCubit>().resetState();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FaceIDScreen(),
                    ),
                  );
                },
              ),

              const Spacer(flex: 1),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) {
                          final apiService = HttpService();
                          return CameraCubit(
                            CameraRepo(apiService),
                            apiService,
                          );
                        },
                        child: const CameraModesScreen(),
                      ),
                    ),
                  );
                },
                child: Column(
                  children: [
                    CustomText(
                      text: 'No thanks,',
                      fontSize: sw * 0.06,
                      fontWeight: FontWeight.bold,
                    ),
                    CustomText(
                      text: 'Just open Robot camera',
                      fontSize: sw * 0.06,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }

  void _showIPSettingsDialog(BuildContext context) {
    final TextEditingController ipController = TextEditingController(
      text: ApiConstants.aiServerIp,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Server Settings"),
        content: TextField(
          controller: ipController,
          decoration: const InputDecoration(labelText: "Robot IP Address"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              ApiConstants.aiServerIp = ipController.text;

              setState(() {});

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("IP Updated to: ${ApiConstants.aiServerIp}"),
                ),
              );
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
