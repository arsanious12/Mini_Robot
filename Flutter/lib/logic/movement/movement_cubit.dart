import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_robo/core/networking/api_constants.dart';
import 'package:mini_robo/core/networking/http_service.dart';
import 'package:mini_robo/core/networking/socket_service.dart';
import 'movement_states.dart';

class MovementCubit extends Cubit<MovementState> {
  final HttpService httpService;
  final SocketService socketService;

  MovementCubit(this.httpService, this.socketService)
    : super(MovementInitial()) {
    _initConnection();
  }
  Timer? _danceTimer;

  void _initConnection() {
    socketService.connect(ApiConstants.socketUrl);
  }

  void sendManualCommand(String cmd) {
    if (socketService.isConnected) {
      socketService.sendCommand(cmd);
    } else {
      emit(MovementError("Could not start the party. Check connection."));
    }
  }

  Future<void> startDanceParty() async {
    emit(MovementLoading());
    try {
      await httpService.sendAiRequest(mode: "D");
      emit(MovementSuccess("The robot is dancing now!"));

      _danceTimer?.cancel();

      _danceTimer = Timer(const Duration(seconds: 30), () {
        if (!isClosed) stopDance();
      });
    } catch (e) {
      emit(MovementError("Could not start the party. Check connection."));
    }
  }

  Future<void> stopDance() async {
    _danceTimer?.cancel();
    try {
      await httpService.sendCommand(ApiConstants.robotStop);
      emit(MovementInitial());
    } catch (e) {
      emit(MovementError("Failed to stop the robot"));
    }
  }

  Future<void> startGreeting() async {
    try {
      await httpService.sendAiRequest(mode: "G");
      emit(MovementSuccess("Robot says Hi! 👋"));
    } catch (e) {
      emit(MovementError("Error sending greeting"));
    }
  }
}
