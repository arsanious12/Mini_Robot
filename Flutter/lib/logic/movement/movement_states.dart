abstract class MovementState {}

class MovementInitial extends MovementState {}

class MovementLoading extends MovementState {}

class MovementSuccess extends MovementState {
  final String message;
  MovementSuccess(this.message);
}

class MovementError extends MovementState {
  final String error;
  MovementError(this.error);
}
