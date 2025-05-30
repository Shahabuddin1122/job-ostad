import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:client/utils/api_settings.dart';
import 'package:client/utils/custom_theme.dart';
import 'package:client/widgets/mcqAnsWidget.dart';

class AnswerScript extends StatefulWidget {
  final String id;
  const AnswerScript({required this.id, super.key});

  @override
  State<AnswerScript> createState() => _AnswerScriptState();
}

class _AnswerScriptState extends State<AnswerScript> {
  final List<Map<String, dynamic>> questions = [];

  @override
  void initState() {
    super.initState();
    fetchQuestion();
  }

  void fetchQuestion() async {
    try {
      ApiSettings apiSettings = ApiSettings(
        endPoint: 'user/get-exam-script?result_id=${widget.id}',
      );
      final response = await apiSettings.getMethod();

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        final List<dynamic> data = json['message'];

        setState(() {
          questions.clear();
          for (var item in data) {
            questions.add({
              "question_id": item["question_id"],
              "question": item["question_text"],
              "options": List<String>.from(item["options"]),
              "subject": item["subject"] ?? "General",
              "image": item["image"] ?? '',
              "correct_answer": item["correct_answer"] ?? '',
              "selected_option": item["selected_option"],
              "is_correct": item["is_correct"],
              "submission_time": item["submission_time"],
            });
          }
        });
      } else {
        print("Unexpected API response: ${response.body}");
      }
    } catch (e) {
      print("Error fetching questions: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Answer Script")),
      body: SingleChildScrollView(
        child: Padding(
          padding: Theme.of(context).defaultPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...questions.asMap().entries.map((entry) {
                int index = entry.key;
                var q = entry.value;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Mcqanswidget(
                    count: index + 1,
                    question: q["question"],
                    options: q["options"],
                    image: q["image"],
                    selectedOption: q["selected_option"] ?? '',
                    correctAnswer: q["correct_answer"] ?? '',
                  ),
                );
              }).toList(),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
