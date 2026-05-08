abstract class CameraState {}

class CameraInitialState extends CameraState {}

class CameraLoadingState extends CameraState {}

class CameraSuccessState extends CameraState {
  final String msg;
  CameraSuccessState(this.msg);
}

class CameraErrorState extends CameraState {
  final String error;

  CameraErrorState(this.error);
}
