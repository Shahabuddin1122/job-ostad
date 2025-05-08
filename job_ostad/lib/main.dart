import 'package:flutter/material.dart';
import 'package:job_ostad/screens/exam_script.dart';
import 'package:job_ostad/screens/landing.dart';
import 'package:job_ostad/screens/signin.dart';
import 'package:job_ostad/screens/signup.dart';
import 'package:job_ostad/utils/scheme.dart';

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
      },
    );
  }
}
