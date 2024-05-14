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
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.all(16),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox.fromSize(size: Size.fromHeight(20)),
                    Text(
                      "Login",
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    SizedBox.fromSize(size: Size.fromHeight(40)),
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        prefixText: '+91 ',
                        hintText: "Enter your 10 digit mobile number",
                      ),
                    ),
                    SizedBox.fromSize(size: Size.fromHeight(10)),
                    // Container(
                    //   padding: EdgeInsets.all(10),
                    //   // margin: EdgeInsets.only(top: 100),
                    //   child: Expanded(
                    //     child: Row(
                    //       children: [
                    //         Text("+91"),
                    //         TextField(
                    //           controller: _phoneController,
                    //           decoration: InputDecoration(
                    //             hintText: "Enter your phone number",
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    Text(
                      "We will send you one time password (OTP)",
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox.fromSize(size: Size.fromHeight(40)),
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
            ),
          ],
        ),
      ),
    );
  }
}
