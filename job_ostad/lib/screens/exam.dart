import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:job_ostad/utils/api_settings.dart';
import 'package:job_ostad/utils/constants.dart';
import 'package:job_ostad/utils/custom_theme.dart';
import 'package:job_ostad/widgets/examCard.dart';

class Exam extends StatefulWidget {
  final String id;
  const Exam({required this.id, super.key});

  @override
  State<Exam> createState() => _ExamState();
}

class _ExamState extends State<Exam> {
  late ApiSettings apiSettings;
  bool isLoading = true;
  List<Map<String, dynamic>> exams = [];

  @override
  void initState() {
    super.initState();
    apiSettings = ApiSettings(
      endPoint: 'quiz/get-all-quiz-by-courseId/${widget.id}',
    );
    fetchExams();
  }

  void fetchExams() async {
    try {
      final response = await apiSettings.getMethod();
      final data = jsonDecode(response.body);
      if (data['success'] == true && data['message'] is List) {
        setState(() {
          exams = List<Map<String, dynamic>>.from(data['message']);
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Error fetching exams: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: Theme.of(context).defaultPadding,
        child:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : exams.isEmpty
                ? Center(child: const Text("No exams available."))
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...exams.map((exam) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Examcard(
                          id: exam['quiz_id'].toString(),
                          desc: exam['description'] ?? '',
                          date: exam['date'] ?? '',
                          num_of_question:
                              exam['number_of_questions'].toString(),
                          time: exam['total_time'].toString(),
                          title: exam['title'] ?? 'No Title',
                          has_exam_script: exam['has_exam_script'],
                        ),
                      );
                    }).toList(),
                  ],
                ),
      ),
    );
  }
}
