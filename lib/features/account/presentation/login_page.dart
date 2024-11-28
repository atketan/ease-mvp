import 'package:ease/features/account/presentation/bloc/login_cubit.dart';
import 'package:ease/features/account/presentation/bloc/login_state.dart';
import 'package:ease/features/account/presentation/otp_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneController = TextEditingController();
  // FirebaseAuth _auth = FirebaseAuth.instance;

  // Future<bool> loginUser(String phone, BuildContext context) async {
  //   _auth.verifyPhoneNumber(
  //     phoneNumber: phone,
  //     timeout: Duration(seconds: 60),
  //     verificationCompleted: (AuthCredential credential) async {
  //       Navigator.of(context).pop();

  //       UserCredential result = await _auth.signInWithCredential(credential);

  //       User? user = result.user;
  //       debugLog(user?.displayName.toString());

  //       if (user != null) {
  //         Navigator.pushAndRemoveUntil(
  //           context,
  //           MaterialPageRoute(builder: (context) => EASEHomePage()),
  //           (Route<dynamic> route) => false,
  //         );
  //       } else {
  //         print("Error");
  //       }
  //     },
  //     verificationFailed: (FirebaseAuthException exception) {
  //       print(exception);
  //     },
  //     codeSent: (String verificationId, int? resendToken) {
  //       showDialog(
  //         context: context,
  //         barrierDismissible: false,
  //         builder: (context) {
  //           return AlertDialog(
  //             title: Text("Enter OTP"),
  //             content: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: <Widget>[
  //                 TextField(
  //                   controller: _codeController,
  //                 ),
  //               ],
  //             ),
  //             actions: <Widget>[
  //               TextButton(
  //                 child: Text("Confirm"),
  //                 // style: TextButton.styleFrom(
  //                 // primary: Colors.white,
  //                 // backgroundColor: Colors.blue,
  //                 // ),
  //                 onPressed: () async {
  //                   final code = _codeController.text.trim();
  //                   AuthCredential credential = PhoneAuthProvider.credential(
  //                       verificationId: verificationId, smsCode: code);

  //                   UserCredential result =
  //                       await _auth.signInWithCredential(credential);

  //                   User? user = result.user;

  //                   if (user != null) {
  //                     Navigator.pushAndRemoveUntil(
  //                       context,
  //                       MaterialPageRoute(builder: (context) => EASEHomePage()),
  //                       (Route<dynamic> route) => false,
  //                     );
  //                   } else {
  //                     print("Error");
  //                   }
  //                 },
  //               )
  //             ],
  //           );
  //         },
  //       );
  //     },
  //     codeAutoRetrievalTimeout: (String verificationId) {},
  //   );
  //   return true;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<LoginCubit, LoginState>(
          bloc: BlocProvider.of<LoginCubit>(context),
          listener: (BuildContext context, state) {
            if (state is LoginOTPSent) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => OTPPage(
                    mobileNumber: state.phoneNumber,
                  ),
                ),
              );
            } else if (state is LoginSuccess) {
              Navigator.of(context).pop();
            }
          },
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 40,
                        ),
                        child: Text(
                          "Login",
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge!
                              .copyWith(
                                color: Theme.of(context).primaryColor,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox.fromSize(size: Size.fromHeight(40)),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 500),
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'We will send you an ',
                              ),
                              TextSpan(
                                  text: 'One Time Password ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                text: 'on this mobile number',
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        constraints: const BoxConstraints(maxWidth: 500),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: CupertinoTextField(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .inputDecorationTheme
                                .fillColor,
                            border: Border.all(
                              color: Theme.of(context).primaryColor,
                              width: 0.5,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(4),
                            ),
                          ),
                          controller: _phoneController,
                          clearButtonMode: OverlayVisibilityMode.editing,
                          keyboardType: TextInputType.phone,
                          maxLines: 1,
                          maxLength: 10,
                          placeholder: "Registered Mobile Number",
                          prefix: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '+91',
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        constraints: const BoxConstraints(maxWidth: 500),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_phoneController.text.isNotEmpty) {
                              final phone =
                                  "+91" + _phoneController.text.trim();
                              // loginUser(phone, context);
                              context
                                  .read<LoginCubit>()
                                  .loginWithPhoneNumber(phone);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.red,
                                  content: Text(
                                    'Please enter a phone number',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              Theme.of(context).primaryColor,
                            ),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 8,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Next',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .color,
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
