// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:logger/logger.dart';

// Project imports:
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/utilities/constants.dart';
//import 'package:flash_chat/utilities/log_printer.dart';

//final logger = Logger(printer: MyLogfmtPrinter('login_screen'));

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String id = '/login';

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String userEmail = '';
  String password = '';
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlurryModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Flexible(
                child: Hero(
                  tag: kLogoHeroTag,
                  child: SizedBox(
                    height: 200.0,
                    child: Image(
                      image: ResizeImage(
                        AssetImage('images/logo.png'),
                        height: 200,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 48.0),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  userEmail = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your email',
                ),
              ),
              const SizedBox(height: 8.0),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your password',
                ),
              ),
              const SizedBox(height: 24.0),
              RoundedButton(
                  color: Colors.lightBlueAccent,
                  text: 'Log In',
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    final navigator = Navigator.of(context);

                    try {
                      await _auth.signInWithEmailAndPassword(
                        email: userEmail,
                        password: password,
                      );

                      setState(() {
                        showSpinner = false;
                      });
                      // ignore: use_build_context_synchronously
                      navigator.pushNamed(ChatScreen.id);
                    } catch (e) {
                      //logger.e(e.toString());
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
