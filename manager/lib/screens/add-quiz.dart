import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:job_ostad/utils/api_settings.dart';
import 'package:job_ostad/utils/constants.dart';
import 'package:job_ostad/utils/custom_theme.dart';

class AddQuiz extends StatefulWidget {
  const AddQuiz({super.key});

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCollection();
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

  void send() async {
    ApiSettings apiSettings = ApiSettings(endPoint: 'quiz/add-a-quiz');

    try {
      Map<String, dynamic> body = {
        "title": titleController.text,
        "description": descController.text,
        "visibility": selectVisiblityValue,
        "number_of_questions": questionController.text,
        "total_time": timeController.text,
        "keywords": keywordsController.text,
        "course_id": selectedCollectionValue,
      };
      final response = await apiSettings.postMethod(jsonEncode(body));

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Quiz uploaded successfully.")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to upload. Status: ${response.statusCode}"),
          ),
        );
      }
    } catch (e) {
      print("Error storing the quiz data: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Quiz")),
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
                  items:
                      collections.map((collection) {
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
                  items:
                      ['Admin', 'Paid_user', 'Free_user'].map((String item) {
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
                spacing: 10,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        send();
                        Navigator.popAndPushNamed(context, '/');
                      },
                      child: Text("Save"),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.popAndPushNamed(context, '/add-question');
                      },
                      child: Text("Add Question"),
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
