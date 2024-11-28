import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String actualCode;

  late User? firebaseUser;

  Future<bool> isAlreadyAuthenticated() async {
    firebaseUser = await _auth.currentUser;
    if (firebaseUser != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> loginWithPhoneNumber(String phoneNumber) async {
    emit(LoginLoading(state: true));
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (AuthCredential authCredential) async {
          await _auth
              .signInWithCredential(authCredential)
              .then((UserCredential value) {
            if (value.user != null) {
              print('Authentication successful');
              firebaseUser = value.user;
              emit(LoginSuccess(message: 'Authentication successful'));
            } else {
              emit(
                  LoginFailure(message: 'Invalid code/invalid authentication'));
            }
          }).catchError((error) {
            emit(LoginFailure(
                message: 'Something has gone wrong, please try later'));
            emit(LoginLoading(state: false));
            return Future<Null>.error(error);
          });
          emit(LoginLoading(state: false));
        },
        verificationFailed: (FirebaseAuthException authException) {
          print('Error message: ' + authException.message.toString());
          if (authException.code == 'recaptcha-verification-failed') {
            emit(LoginFailure(
                message: 'reCAPTCHA verification failed. Please try again.'));
          } else {
            emit(
              LoginFailure(
                message:
                    'The phone number format is incorrect. Please enter your number in E.164 format. [+][country code][number]',
              ),
            );
          }
          emit(LoginLoading(state: false));
        },
        codeSent: (String verificationId, int? forceResendingToken) async {
          actualCode = verificationId;
          emit(LoginLoading(state: false));
          emit(LoginOTPSent(phoneNumber: phoneNumber));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          actualCode = verificationId;
        });
  }

  Future<void> validateOtpAndLogin(String smsCode) async {
    final AuthCredential _authCredential = PhoneAuthProvider.credential(
      verificationId: actualCode,
      smsCode: smsCode,
    );

    await _auth.signInWithCredential(_authCredential).catchError((error) {
      emit(
        LoginReenterOTP(
          message: 'Wrong code! Please enter the last code received.',
        ),
      );
      return Future<UserCredential>.error(error);
    }).then((UserCredential userCredential) {
      if (userCredential.user != null) {
        print('Authentication successful');
        emit(LoginSuccess(message: 'Authentication successful'));
        firebaseUser = userCredential.user;
      }
    });
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    emit(LoginLoading(state: true));
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      firebaseUser = userCredential.user;
      emit(LoginSuccess(message: 'Authentication successful'));
    } on FirebaseAuthException catch (e) {
      emit(LoginFailure(message: e.message ?? 'Login failed'));
    } finally {
      emit(LoginLoading(state: false));
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    emit(LoginSignedOut());
    firebaseUser = null;
  }
}