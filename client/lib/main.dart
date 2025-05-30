import 'package:flutter/material.dart';
import 'package:client/screens/answer_script.dart';
import 'package:client/screens/exam_script.dart';
import 'package:client/screens/landing.dart';
import 'package:client/screens/profile_info.dart';
import 'package:client/screens/signin.dart';
import 'package:client/screens/signup.dart';
import 'package:client/utils/scheme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      theme: Scheme.lightTheme,
      darkTheme: Scheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => Landing(),
        '/sign-in': (context) => Signin(),
        '/sign-up': (context) => Signup(),
        '/exam-script': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as String;
          return ExamScript(id: args);
        },
        '/answer-script': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as String;
          return AnswerScript(id: args);
        },
        '/profile-info': (context) {
          return ProfileInfo();
        },
      },
    );
  }
}
