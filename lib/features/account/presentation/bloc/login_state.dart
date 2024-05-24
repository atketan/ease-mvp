abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginPressed extends LoginState {
  final String phoneNumber;

  LoginPressed({required this.phoneNumber});
}

class LoginLoading extends LoginState {
  final bool state; // start, stop
  LoginLoading({required this.state});
}

class LoginSuccess extends LoginState {
  final String message;

  LoginSuccess({required this.message});
}

class LoginFailure extends LoginState {
  final String message;

  LoginFailure({required this.message});
}

class LoginOTPSent extends LoginState {
  final String phoneNumber;

  LoginOTPSent({required this.phoneNumber});
}

class LoginReenterOTP extends LoginState {
  final String message;

  LoginReenterOTP({required this.message});
}

class LoginOTPVerified extends LoginState {
  final String smsCode;

  LoginOTPVerified({required this.smsCode});
}

class LoginSignedOut extends LoginState {}
