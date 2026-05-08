import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_robo/core/utils/app_colors.dart';
import 'package:mini_robo/features/feedback/widgets/feedback_screen.dart';
import 'package:mini_robo/logic/camera/cubit/camera_cubit.dart';
import 'package:mini_robo/logic/camera/cubit/camera_states.dart';
import 'package:mini_robo/features/camera_screens/widgets/camera_file.dart';
import 'package:mini_robo/shared/buttons/custom_button.dart';
import 'package:mini_robo/shared/buttons/custom_modes_buttons.dart';
import 'package:mini_robo/shared/texts/custom_text.dart';
import 'package:mini_robo/shared/texts/custom_title.dart';

class CameraModesScreen extends StatefulWidget {
  const CameraModesScreen({super.key});

  @override
  State<CameraModesScreen> createState() => _CameraModesScreenState();
}

class _CameraModesScreenState extends State<CameraModesScreen> {
  String myMode = "";

  void _activeRobotMode(String mode) async {
    setState(() {
      myMode = mode;
    });

    if (mounted) {
      if (mode == "Greeting") {
        context.read<CameraCubit>().activateGreeting();
      } else {
        String apiMode = (mode == "Object") ? "O" : "F";
        context.read<CameraCubit>().activateMode(apiMode);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double sw = MediaQuery.of(context).size.width;
    final double sh = MediaQuery.of(context).size.height;

    return BlocConsumer<CameraCubit, CameraState>(
      listener: (context, state) {
        if (state is CameraErrorState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
        } else if (state is CameraSuccessState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.msg)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: sw * 0.05,
                    vertical: sw * 0.15,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: sw * 0.05,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FeedbackScreen(),
                                ),
                              ),
                              icon: Icon(
                                Icons.arrow_back_ios_rounded,
                                size: sw * 0.07,
                                color: AppColors.icons,
                              ),
                            ),
                          ),

                          const Expanded(
                            child: Center(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: CustomTitle(),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const Spacer(flex: 1),

                      CustomText(
                        text: 'Which mode do you\nwant to try today?',
                        fontSize: sw * 0.07,
                        fontWeight: FontWeight.bold,
                      ),

                      const Spacer(flex: 1),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildModeBtn("Face ID", sw, sh, isNav: true),
                          _buildModeBtn("Detection", sw, sh, mode: "Object"),
                          _buildModeBtn("Greeting", sw, sh, mode: "Greeting"),
                        ],
                      ),

                      SizedBox(height: sh * 0.04),

                      CustomModesButtons(
                        text: state is CameraSuccessState
                            ? state.msg
                            : (myMode == "Object"
                                  ? "Object is scanning..."
                                  : "  Ready to Process ✨"),
                      ),

                      const Spacer(flex: 2),
                    ],
                  ),
                ),

                if (state is CameraLoadingState)
                  Container(
                    color: Colors.black26,
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.cyan),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Extracted button helper to keep code clean
  Widget _buildModeBtn(
    String text,
    double sw,
    double sh, {
    bool isNav = false,
    String? mode,
  }) {
    return CustomButton(
      text: text,
      fontSize: sw * 0.02,
      width: sw * 0.28,
      height: sh * 0.07,
      isActive: mode != null && myMode == mode,
      onTap: isNav
          ? () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<CameraCubit>(),
                  child: const FaceIDScreen(),
                ),
              ),
            )
          : () => _activeRobotMode(mode!),
    );
  }
}
