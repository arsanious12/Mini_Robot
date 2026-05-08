import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_robo/core/networking/http_service.dart';
import 'package:mini_robo/core/networking/socket_service.dart';
import 'package:mini_robo/logic/camera/data/repos/camera_repo.dart';
import 'package:mini_robo/logic/camera/cubit/camera_cubit.dart';
import 'package:mini_robo/logic/movement/movement_cubit.dart';
import 'package:mini_robo/start_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MovementCubit(HttpService(), SocketService()),
        ),
        BlocProvider(
          create: (context) =>
              CameraCubit(CameraRepo(HttpService()), HttpService()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mini Robot',
      theme: ThemeData(
        splashColor: Colors.transparent,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: Start(),
    );
  }
}
