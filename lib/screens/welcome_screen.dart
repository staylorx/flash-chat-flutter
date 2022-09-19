// Flutter imports:
// ignore_for_file: prefer_const_constructors

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:logger/logger.dart';

// Project imports:
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/utilities/constants.dart';
import 'package:flash_chat/utilities/log_printer.dart';

final logger = Logger(printer: MyLogfmtPrinter('welcome_screen'));

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  static const String id = '/';

  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  // late AnimationController controller;
  // late Animation animation;

  @override
  void initState() {
    super.initState();

    // controller = AnimationController(
    //   duration: const Duration(seconds: 1),
    //   vsync: this,
    // );

    // // animation = CurvedAnimation(
    // //   parent: controller,
    // //   curve: Curves.easeIn,
    // // );
    // animation = ColorTween(
    //   begin: Colors.blueGrey,
    //   end: Colors.white,
    // ).animate(controller);

    // controller.forward();

    // controller.addListener(() {
    //   setState(() {});
    // });
  }

  @override
  void dispose() {
    //controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: animation.value,
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                const Hero(
                  tag: kLogoHeroTag,
                  child: SizedBox(
                    height: 60.0,
                    child: Image(
                      image: ResizeImage(
                        AssetImage('images/logo.png'),
                        height: 60,
                      ),
                    ),
                  ),
                ),
                AnimatedTextKit(
                  isRepeatingAnimation: false,
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Flash Chat',
                      speed: const Duration(milliseconds: 100),
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 45.0,
                        fontWeight: FontWeight.w900,
                      ),
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              color: Colors.lightBlueAccent,
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
              text: 'Log in',
            ),
            RoundedButton(
              color: Colors.blueAccent,
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
              text: 'Register',
            ),
          ],
        ),
      ),
    );
  }
}
