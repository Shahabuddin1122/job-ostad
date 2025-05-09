import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:job_ostad/utils/api_settings.dart';
import 'package:job_ostad/utils/constants.dart';
import 'package:job_ostad/utils/custom_theme.dart';
import 'package:job_ostad/widgets/mcq_widget.dart';
import 'dart:async';

class ExamScript extends StatefulWidget {
  final String id;
  const ExamScript({required this.id, super.key});

  @override
  _ExamScriptState createState() => _ExamScriptState();
}

class _ExamScriptState extends State<ExamScript> {
  late Timer _timer;
  late int _seconds;
  final ScrollController _scrollController = ScrollController();
  String? selectedSubject = "All";
  String? title;
  int numberOfQuestions = 0;
  int totalTime = 0;

  // Question dictionary
  final List<Map<String, dynamic>> questions = [];

  // Get unique subjects with "All" option
  List<String> get uniqueSubjects {
    final subjects =
        questions.map((q) => q["subject"] as String).toSet().toList();
    return ["All"] + subjects; // Add "All" at the beginning
  }

  // Filter questions by subject
  List<Map<String, dynamic>> get filteredQuestions {
    if (selectedSubject == null || selectedSubject == "All") {
      return questions; // Show all questions if "All" is selected
    }
    return questions.where((q) => q["subject"] == selectedSubject).toList();
  }

  @override
  void initState() {
    super.initState();
    _seconds = 0;
    _startTimer();
    fetchQuestion();
  }

  void fetchQuestion() async {
    try {
      ApiSettings apiSettings = ApiSettings(
        endPoint: 'exam/get-question-by-quiz-id/${widget.id}',
      );
      final response = await apiSettings.getMethod();

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        final List<dynamic> data = json['data']['questions'];

        setState(() {
          title = json["data"]["title"];
          totalTime = json["data"]["total_time"];
          numberOfQuestions = json["data"]["number_of_questions"];
          _seconds = totalTime.toInt() * 60;
          questions.clear();
          for (var item in data) {
            questions.add({
              "question": item["question"],
              "options": List<String>.from(item["options"]),
              "subject": item["subject"] ?? "General",
              "image": item["image"] ?? '',
            });
          }
        });
      } else {
        // Handle unexpected structure or empty response
        print("Unexpected API response: $response");
      }
    } catch (e) {
      print("Error fetching questions: $e");
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        setState(() {
          _seconds--;
        });
      } else {
        _timer.cancel();
      }
    });
  }

  void _scrollToQuestion(int index) {
    final double offset = index * 150.0;
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  String _formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;
    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _timer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? ''),
        actions: [
          Container(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                _formatTime(_seconds),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _seconds <= 60 ? Colors.red : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              spacing: 10,
              children: [
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: filteredQuestions.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 2,
                          vertical: 10,
                        ),
                        child: ElevatedButton(
                          onPressed: () => _scrollToQuestion(index),
                          child: Text("Q${index + 1}"),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: SizedBox(
                    height: 40,
                    child: DropdownButton<String>(
                      value: selectedSubject,
                      hint: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("Subject"),
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedSubject = newValue;
                        });
                      },
                      items:
                          uniqueSubjects.map<DropdownMenuItem<String>>((
                            String value,
                          ) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 0.0,
                                ),
                                child: Text(value),
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: Theme.of(context).defaultPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    ...filteredQuestions.map((q) {
                      return MCQWidget(
                        count: filteredQuestions.indexOf(q) + 1,
                        question: q["question"],
                        options: q["options"],
                        image: q["image"],
                      );
                    }).toList(),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: FloatingActionButton.extended(
            onPressed: () {},
            label: const Text(
              "Submit Test",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            icon: const Icon(Icons.check, color: Colors.white),
            backgroundColor: PRIMARY_COLOR,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
