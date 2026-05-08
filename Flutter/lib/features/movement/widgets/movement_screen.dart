import 'package:flutter/material.dart';
import 'package:mini_robo/core/networking/api_constants.dart';
import 'package:mini_robo/features/movement/widgets/custom_switch.dart';
import 'package:mini_robo/shared/texts/custom_title.dart';

class Movement extends StatefulWidget {
  const Movement({super.key});

  @override
  State<Movement> createState() => _MovementState();
}

class _MovementState extends State<Movement> {
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

              const Expanded(flex: 5, child: SwitchCustom()),

              Flexible(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/images/robot_walk.png",
                      height: sh * 0.25,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
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
              ApiConstants.robotIp = ipController.text;

              setState(() {});

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("IP Updated to: ${ApiConstants.robotIp}"),
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
