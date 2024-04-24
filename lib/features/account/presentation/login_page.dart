import 'package:ease_mvp/features/home/presentation/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> loginUser(String phone, BuildContext context) async {
    _auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: Duration(seconds: 60),
      verificationCompleted: (AuthCredential credential) async {
        Navigator.of(context).pop();

        UserCredential result = await _auth.signInWithCredential(credential);

        User? user = result.user;
        debugPrint(user?.displayName.toString());

        if (user != null) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => EASEHomePage()),
            (Route<dynamic> route) => false,
          );
        } else {
          print("Error");
        }
      },
      verificationFailed: (FirebaseAuthException exception) {
        print(exception);
      },
      codeSent: (String verificationId, int? resendToken) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text("Enter OTP"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: _codeController,
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text("Confirm"),
                  // style: TextButton.styleFrom(
                  // primary: Colors.white,
                  // backgroundColor: Colors.blue,
                  // ),
                  onPressed: () async {
                    final code = _codeController.text.trim();
                    AuthCredential credential = PhoneAuthProvider.credential(
                        verificationId: verificationId, smsCode: code);

                    UserCredential result =
                        await _auth.signInWithCredential(credential);

                    User? user = result.user;

                    if (user != null) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => EASEHomePage()),
                        (Route<dynamic> route) => false,
                      );
                    } else {
                      print("Error");
                    }
                  },
                )
              ],
            );
          },
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
    return true; // Replace with your desired return value
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              // margin: EdgeInsets.only(top: 100),
              child: TextField(
                controller: _phoneController,
                decoration:
                    InputDecoration(hintText: "Enter your phone number"),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  final phone = _phoneController.text.trim();

                  loginUser(phone, context);
                },
                // style: ElevatedButton.styleFrom(
                // backgroundColor: Colors.blue, // background color
                // onPrimary: Colors.white, // text color
                // ),
                child: Text(
                  "Verify",
                  // style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
