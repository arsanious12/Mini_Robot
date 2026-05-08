import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mini_robo/core/utils/app_colors.dart';
import 'package:mini_robo/logic/camera/cubit/camera_cubit.dart';
import 'package:mini_robo/logic/camera/cubit/camera_states.dart';
import 'package:mini_robo/shared/buttons/custom_button.dart';
import 'package:mini_robo/shared/texts/custom_text.dart';
import 'package:mini_robo/shared/texts/custom_textfield.dart';
import 'package:mini_robo/shared/texts/custom_title.dart';

class FaceIDScreen extends StatefulWidget {
  const FaceIDScreen({super.key});

  @override
  State<FaceIDScreen> createState() => _FaceIDScreenState();
}

class _FaceIDScreenState extends State<FaceIDScreen> {
  final TextEditingController _userNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? image;
  final picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() => image = File(pickedFile.path));
    }
  }

  @override
  void dispose() {
    _userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double sw = screenSize.width;
    final double sh = screenSize.height;

    return BlocConsumer<CameraCubit, CameraState>(
      listener: (context, state) {
        if (state is CameraSuccessState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.msg)));
          Navigator.pop(context);
        } else if (state is CameraErrorState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Registration failed")));
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: sw * 0.05,
                vertical: sh * 0.03,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: sh * 0.02),
                    Row(
                      children: [
                        SizedBox(
                          width: sw * 0.05, // تحديد عرض ثابت لمنطقة الزر
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () => Navigator.pop(context),
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
                    SizedBox(height: sh * 0.04),
                    Container(
                      height: sh * 0.35,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: image != null
                            ? Image.file(image!, fit: BoxFit.cover)
                            : Center(
                                child: CustomText(
                                  text: "No image selected",
                                  fontSize: sw * 0.05,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: sh * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomButton(
                          text: "Camera",
                          fontSize: sw * 0.05,
                          width: sw * 0.42,
                          height: sh * 0.07,
                          onTap: () => pickImage(ImageSource.camera),
                        ),
                        CustomButton(
                          text: "Gallery",
                          fontSize: sw * 0.05,
                          width: sw * 0.42,
                          height: sh * 0.07,
                          onTap: () => pickImage(ImageSource.gallery),
                        ),
                      ],
                    ),
                    SizedBox(height: sh * 0.04),
                    CustomButton(
                      text: "Please Enter Your First Name",
                      fontSize: sw * 0.045,
                      width: double.infinity,
                      height: sh * 0.08,
                      fontColor: const Color(0xffEBEBEB),
                      onTap: () {},
                    ),
                    SizedBox(height: sh * 0.02),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: CustomTextField(
                            hintText: 'First Name',
                            controller: _userNameController,
                          ),
                        ),
                        SizedBox(width: sw * 0.02),
                        Expanded(
                          flex: 1,
                          child: CustomButton(
                            fontSize: sw * 0.04,
                            width: sw * 0.2,
                            height: sh * 0.07,
                            fontColor: AppColors.textColor2,
                            text: state is CameraLoadingState ? "..." : "Done",
                            onTap: state is CameraLoadingState
                                ? () {}
                                : _handleSubmit,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: sh * 0.03),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      if (image == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select image first")),
        );
        return;
      }
      context.read<CameraCubit>().registerUser(
        _userNameController.text,
        image!,
      );
    }
  }
}
