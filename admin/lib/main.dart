import 'package:flutter/material.dart';
import 'package:admin/screens/add-book.dart';
import 'package:admin/screens/add-course.dart';
import 'package:admin/screens/add-question.dart';
import 'package:admin/screens/add-quiz.dart';
import 'package:admin/screens/exam_script.dart';
import 'package:admin/screens/landing.dart';
import 'package:admin/utils/scheme.dart';

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
        '/add-book': (context) => AddBook(),
        '/add-course': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>?;
          return AddCourse(courseId: args?['courseId']);
        },
        '/add-quiz': (context) => AddQuiz(),
        '/add-question': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as List;
          final String id = args[0] as String;
          final int number_of_questions = args[1] as int;
          return AddQuestion(id: id, number_of_questions: number_of_questions);
        },
        '/question-paper': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as String;
          return ExamScript(id: args);
        },
      },
    );
  }
}
