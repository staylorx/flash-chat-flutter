import 'dart:io' as io;

import 'package:flash_chat/utilities/log_printer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:logger/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final logger = Logger(printer: MyLogfmtPrinter("main"));

void main() async {
  if (kReleaseMode) {
    Logger.level = Level.info;
    String fileName = '.env.prod';
    logger.d("main: Setting production mode with $fileName");

    await openEnvFile(fileName);
  } else {
    Logger.level = Level.debug;
    String fileName = '.env.dev';
    logger.d("main: Setting development mode with $fileName");

    await openEnvFile(fileName);
  }

  runApp(const FlashChat());
}

Future<void> openEnvFile(fileName) async {
  //check for file
  var fileExists = await io.File(fileName).exists();
  if (fileExists) {
    await dotenv.load(fileName: fileName);
  } else {
    logger.w("$fileName file does not exist... skipping.");
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
      home: const WelcomeScreen(),
    );
  }
}
