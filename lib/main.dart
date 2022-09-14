// Dart imports:
import 'dart:io' as io;

// Flutter imports:
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

// Project imports:
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/utilities/log_printer.dart';

final logger = Logger(printer: MyLogfmtPrinter('main'));

void main() async {
  if (kDebugMode) {
    Logger.level = Level.debug;
    String fileName = '.env.dev';
    logger.d('main: Setting development mode with $fileName');

    await _openEnvFile(fileName: fileName);
  } else {
    Logger.level = Level.info;
    String fileName = '.env.prod';
    logger.d('main: Setting production mode with $fileName');

    await _openEnvFile(fileName: fileName);
  }

  runApp(const FlashChat());
}

Future<void> _openEnvFile({required String fileName}) async {
  //check for file
  var fileExists = await io.File(fileName).exists();
  if (fileExists) {
    await dotenv.load(fileName: fileName);
  } else {
    logger.w('$fileName file does not exist... skipping.');
  }
}

class FlashChat extends StatelessWidget {
  const FlashChat({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        textTheme: const TextTheme(
          bodyText1: TextStyle(color: Colors.black54),
        ),
      ),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => const WelcomeScreen(),
        RegistrationScreen.id: (context) => const RegistrationScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        ChatScreen.id: (context) => const ChatScreen(),
      },
    );
  }
}
