import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:admin/utils/api_settings.dart';
import 'package:admin/utils/constants.dart';
import 'package:admin/utils/custom_theme.dart';

class AddQuiz extends StatefulWidget {
  final String? callbackQuizId; // null = create, not null = edit
  const AddQuiz({this.callbackQuizId, super.key});

  @override
  State<AddQuiz> createState() => _AddQuizState();
}

class _AddQuizState extends State<AddQuiz> {
  String? selectedCollectionValue;
  String? selectVisiblityValue;
  List<Map<String, dynamic>> collections = [];
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController questionController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController keywordsController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  String quizId = '';
  int num_of_question = 0;
  bool isEditMode = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCollection();

    if (widget.callbackQuizId != null) {
      isEditMode = true;
      fetchQuizData(widget.callbackQuizId!);
    }
  }

  void getCollection() async {
    ApiSettings apiSettings = ApiSettings(
      endPoint: 'course/get-all-collection',
    );

    try {
      final response = await apiSettings.getMethod();
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          collections = List<Map<String, dynamic>>.from(data['data']);
        });
      }
    } catch (e) {
      print("Error fetching collections: $e");
    }
  }

  Future<bool> send() async {
    if (selectedCollectionValue == null || selectVisiblityValue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select collection and visibility.")),
      );
      return false;
    }

    Map<String, dynamic> body = {
      "title": titleController.text,
      "description": descController.text,
      "date": dateController.text,
      "visibility": selectVisiblityValue,
      "number_of_questions": questionController.text,
      "total_time": timeController.text,
      "keywords": keywordsController.text,
      "course_id": selectedCollectionValue,
    };

    try {
      late final response;
      if (isEditMode) {
        ApiSettings apiSettings = ApiSettings(
          endPoint: 'quiz/update-quiz/$quizId',
        );
        response = await apiSettings.putMethod(jsonEncode(body));
      } else {
        ApiSettings apiSettings = ApiSettings(endPoint: 'quiz/add-a-quiz');
        response = await apiSettings.postMethod(jsonEncode(body));
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (!isEditMode) {
          setState(() {
            quizId = data['data']['id'].toString();
            num_of_question = data['data']['number_of_questions'];
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditMode
                  ? "Quiz updated successfully."
                  : "Quiz uploaded successfully.",
            ),
          ),
        );
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed. Status: ${response.statusCode}")),
        );
        return false;
      }
    } catch (e) {
      print("Error storing quiz: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
      return false;
    }
  }

  void fetchQuizData(String id) async {
    ApiSettings apiSettings = ApiSettings(endPoint: 'quiz/get-quiz-by-id/$id');
    try {
      final response = await apiSettings.getMethod();
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        setState(() {
          quizId = data['id'].toString();
          titleController.text = data['title'] ?? '';
          descController.text = data['description'] ?? '';
          dateController.text = data['date'] ?? '';
          selectVisiblityValue = data['visibility'];
          questionController.text = data['number_of_questions'].toString();
          timeController.text = data['total_time'].toString();
          keywordsController.text = data['keywords'] ?? '';
          selectedCollectionValue = data['course_id'].toString();
          num_of_question = data['number_of_questions'];
        });
      }
    } catch (e) {
      print("Error loading quiz: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditMode ? "Edit Quiz" : "Add Quiz")),
      body: SingleChildScrollView(
        child: Padding(
          padding: Theme.of(context).defaultPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Title",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: "Enter Title",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: PRIMARY_COLOR, width: 2),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: PRIMARY_COLOR, width: 2),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Description",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: descController,
                decoration: InputDecoration(
                  hintText: "Enter Description",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: PRIMARY_COLOR, width: 2),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: PRIMARY_COLOR, width: 2),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Date",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: dateController,
                readOnly: true,
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    dateController.text = "${picked.toLocal()}".split(' ')[0];
                  }
                },
                decoration: InputDecoration(
                  hintText: "Select date",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: PRIMARY_COLOR, width: 2),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: PRIMARY_COLOR, width: 2),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Collection",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 2.0, color: PRIMARY_COLOR),
                  ),
                ),
                child: DropdownButton<String>(
                  hint: Text(
                    'Select a Collection',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  value: selectedCollectionValue,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  underline: SizedBox(),
                  alignment: Alignment.centerLeft,
                  items: collections.map((collection) {
                    return DropdownMenuItem<String>(
                      value: collection['id'].toString(),
                      child: Text(collection['title']),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCollectionValue = newValue;
                    });
                  },
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Visiblity",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 2.0, color: PRIMARY_COLOR),
                  ),
                ),
                child: DropdownButton<String>(
                  hint: Text(
                    'Select Visibility',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  value: selectVisiblityValue,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  underline: SizedBox(),
                  alignment: Alignment.centerLeft,
                  items: ['Admin', 'Paid_user', 'Free_user'].map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectVisiblityValue = newValue;
                    });
                  },
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Number of Question",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: questionController,
                decoration: InputDecoration(
                  hintText: "Enter number of question",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: PRIMARY_COLOR, width: 2),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: PRIMARY_COLOR, width: 2),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Time",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: timeController,
                decoration: InputDecoration(
                  hintText: "Enter time",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: PRIMARY_COLOR, width: 2),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: PRIMARY_COLOR, width: 2),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Keywords",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: keywordsController,
                decoration: InputDecoration(
                  hintText: "Write keywords and Press Enter",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: PRIMARY_COLOR, width: 2),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: PRIMARY_COLOR, width: 2),
                  ),
                ),
              ),
              SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final success = await send();
                        if (success) Navigator.popAndPushNamed(context, '/');
                      },
                      child: Text(isEditMode ? "Update" : "Save"),
                    ),
                  ),
                  if (!isEditMode) SizedBox(width: 10),
                  if (!isEditMode)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final success = await send();
                          if (success) {
                            Navigator.popAndPushNamed(
                              context,
                              '/add-question',
                              arguments: [quizId, num_of_question],
                            );
                          }
                        },
                        child: const Text("Add Question"),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
