// import 'package:ease_mvp/features/account/presentation/login_page.dart';
// import 'package:ease_mvp/features/account/presentation/otp_page.dart';
// import 'package:ease_mvp/features/home/presentation/home_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class LoginCore {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   late String actualCode;

//   GlobalKey<ScaffoldState> loginScaffoldKey = GlobalKey<ScaffoldState>();

//   GlobalKey<ScaffoldState> otpScaffoldKey = GlobalKey<ScaffoldState>();

//   bool isLoginLoading = false;
//   bool isOtpLoading = false;
//   late User? firebaseUser;

//   Future<bool> isAlreadyAuthenticated() async {
//     firebaseUser = await _auth.currentUser;
//     if (firebaseUser != null) {
//       return true;
//     } else {
//       return false;
//     }
//   }

//   Future<Response> getCodeWithPhoneNumber(
//       BuildContext context, String phoneNumber) async {
//     isLoginLoading = true;

//     await _auth.verifyPhoneNumber(
//         phoneNumber: phoneNumber,
//         timeout: const Duration(seconds: 60),
//         verificationCompleted: (AuthCredential auth) async {
//           await _auth.signInWithCredential(auth).then((UserCredential value) {
//             if (value.user != null) {
//               print('Authentication successful');
//               onAuthenticationSuccessful(context, value);
//             } else {
//               // add code for using the loginscaffoldkey for showing a snackbar
//               return Response(message: 'Invalid code/invalid authentication', success: false);
//               // loginScaffoldKey.currentState.(SnackBar(
//               //   behavior: SnackBarBehavior.floating,
//               //   backgroundColor: Colors.red,
//               //   content: Text(
//               //     'Invalid code/invalid authentication',
//               //     style: TextStyle(color: Colors.white),
//               //   ),
//               // ));
//             }
//           }).catchError((error) {
//             return Response(message: 'Something has gone wrong, please try later', success: false);
//             // loginScaffoldKey.currentState.showSnackBar(SnackBar(
//             //   behavior: SnackBarBehavior.floating,
//             //   backgroundColor: Colors.red,
//             //   content: Text(
//             //     'Something has gone wrong, please try later',
//             //     style: TextStyle(color: Colors.white),
//             //   ),
//             // ));
//           });
//         },
//         verificationFailed: (FirebaseAuthException authException) {
//           debugPrint('Error message: ' + authException.message.toString());
//           isLoginLoading = false;
//           return Response(message: 'The phone number format is incorrect. Please enter your number in E.164 format. [+][country code][number]', success: false);
//           // loginScaffoldKey.currentState.showSnackBar(SnackBar(
//           //   behavior: SnackBarBehavior.floating,
//           //   backgroundColor: Colors.red,
//           //   content: Text(
//           //     'The phone number format is incorrect. Please enter your number in E.164 format. [+][country code][number]',
//           //     style: TextStyle(color: Colors.white),
//           //   ),
//           // ));
          
//         },
//         codeSent: (String verificationId, int? forceResendingToken) async {
//           actualCode = verificationId;
//           isLoginLoading = false;
//           await Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (_) => OTPPage(mobileNumber: phoneNumber),
//             ),
//           );
//         },
//         codeAutoRetrievalTimeout: (String verificationId) {
//           actualCode = verificationId;
//         });
//   }

//   Future<void> validateOtpAndLogin(BuildContext context, String smsCode) async {
//     isOtpLoading = true;
//     final AuthCredential _authCredential = PhoneAuthProvider.getCredential(
//         verificationId: actualCode, smsCode: smsCode);

//     await _auth.signInWithCredential(_authCredential).catchError((error) {
//       isOtpLoading = false;
//       otpScaffoldKey.currentState.showSnackBar(SnackBar(
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: Colors.red,
//         content: Text(
//           'Wrong code ! Please enter the last code received.',
//           style: TextStyle(color: Colors.white),
//         ),
//       ));
//     }).then((AuthResult authResult) {
//       if (authResult != null && authResult.user != null) {
//         print('Authentication successful');
//         onAuthenticationSuccessful(context, authResult);
//       }
//     });
//   }

//   Future<void> onAuthenticationSuccessful(
//       BuildContext context, AuthResult result) async {
//     isLoginLoading = true;
//     isOtpLoading = true;

//     firebaseUser = result.user;

//     Navigator.of(context).pushAndRemoveUntil(
//         MaterialPageRoute(builder: (_) => const EASEHomePage()),
//         (Route<dynamic> route) => false);

//     isLoginLoading = false;
//     isOtpLoading = false;
//   }

//   Future<void> signOut(BuildContext context) async {
//     await _auth.signOut();
//     await Navigator.of(context).pushAndRemoveUntil(
//         MaterialPageRoute(builder: (_) => LoginPage()),
//         (Route<dynamic> route) => false);
//     firebaseUser = null;
//   }
// }

// class Response{
//   final String message;
//   final bool success;

//   Response({required this.message, required this.success});
// }