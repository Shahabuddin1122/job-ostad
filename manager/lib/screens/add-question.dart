import 'dart:convert';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:manager/utils/api_settings.dart';
import 'package:manager/utils/constants.dart';
import 'package:manager/utils/custom_theme.dart';

class AddQuestion extends StatefulWidget {
  final String id;
  final int number_of_questions;
  const AddQuestion({
    required this.number_of_questions,
    required this.id,
    super.key,
  });

  @override
  State<AddQuestion> createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  List<Map<String, dynamic>> questions = [
    {
      'image': null,
      'question': '',
      'answer': '',
      'options': <String>[],
      'subject': null,
    },
  ];

  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _optionController = TextEditingController();
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  int _currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    _optionController.dispose();
    _questionController.dispose();
    super.dispose();
  }

  Future<void> pickImage(int index) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        questions[index]['image'] = File(result.files.single.path!);
      });
    }
  }

  void addOption(int index) {
    if (_optionController.text.isNotEmpty &&
        questions[index]['options'].length < 4) {
      setState(() {
        questions[index]['options'].add(_optionController.text);
        _optionController.clear();
      });
    }
  }

  void removeOption(int index, String option) {
    setState(() {
      questions[index]['options'].remove(option);
    });
  }

  void addNewQuestion() {
    if (questions.length < widget.number_of_questions) {
      setState(() {
        questions.add({
          'image': null,
          'question': '',
          'answer': '',
          'options': <String>[],
          'subject': null,
        });
        _currentIndex = questions.length - 1;
        _questionController.clear();
      });

      _pageController.animateToPage(
        _currentIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  void saveQuestion(int index) {
    setState(() {
      questions[index]['question'] = _questionController.text;
    });
  }

  void saveAnswer(int index) {
    setState(() {
      questions[index]['answer'] = _answerController.text;
    });
  }

  void saveToDatabase() async {
    final uri = Uri.parse('${baseUri}exam/create-question');
    final request = http.MultipartRequest('POST', uri);

    request.fields['quiz_id'] = widget.id;

    // Build the questions list
    List<Map<String, dynamic>> payload = [];
    for (var q in questions) {
      payload.add({
        'question': q['question'],
        'answer': q['answer'],
        'options': q['options'],
        'subject': q['subject'],
      });

      // If image exists, add it as a multipart file
      if (q['image'] != null && q['image'] is File) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'images', // this key must match the expected backend key
            q['image'].path,
          ),
        );
      }
    }

    request.fields['questions'] = jsonEncode(payload);

    try {
      final response = await request.send();
      final resBody = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Questions uploaded successfully!")),
        );
        Navigator.popAndPushNamed(context, '/');
      } else {
        print('Error ${response.statusCode}: $resBody');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to upload questions.")));
      }
    } catch (e) {
      print('Exception: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Question")),
      body: PageView.builder(
        controller: _pageController,
        itemCount: questions.length,
        scrollDirection: Axis.horizontal,
        onPageChanged: (index) {
          // Save current question before switching
          if (_currentIndex < questions.length) {
            saveQuestion(_currentIndex);
            saveAnswer(_currentIndex);
          }
          setState(() {
            _currentIndex = index;
            // Update controllers with current question data
            _questionController.text = questions[index]['question'] ?? '';
            _answerController.text = questions[index]['answer'] ?? '';
          });
        },
        itemBuilder: (context, index) {
          return SingleChildScrollView(
            child: Padding(
              padding: Theme.of(context).defaultPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => pickImage(index),
                    child: Center(
                      child: DottedBorder(
                        options: RoundedRectDottedBorderOptions(
                          color: PRIMARY_COLOR,
                          strokeWidth: 3,
                          radius: Radius.circular(5),
                          dashPattern: [10, 5],
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          height: 200,
                          child: questions[index]['image'] == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.image, size: 45),
                                    Text("Upload Image"),
                                  ],
                                )
                              : Image.file(
                                  questions[index]['image'],
                                  fit: BoxFit.cover,
                                  width: 150,
                                  height: 150,
                                ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Subject",
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
                        'Select Subject',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      value: questions[index]['subject'],
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      underline: SizedBox(),
                      alignment: Alignment.centerLeft,
                      items: ['Bangla', 'English', 'Math'].map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          questions[index]['subject'] = newValue;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Question",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: _questionController,
                    onChanged: (value) {
                      questions[index]['question'] = value;
                    },
                    decoration: InputDecoration(
                      hintText: "Enter Question",
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
                    "Answer",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: _answerController,
                    onChanged: (value) {
                      questions[index]['answer'] = value;
                    },
                    decoration: InputDecoration(
                      hintText: "Enter Answer",
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
                    "Options",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Column(
                    children: questions[index]['options'].map<Widget>((option) {
                      return Container(
                        margin: EdgeInsets.only(top: 5),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: PRIMARY_COLOR, width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(option),
                            IconButton(
                              icon: Icon(Icons.close, color: Colors.red),
                              onPressed: () => removeOption(index, option),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: PRIMARY_COLOR, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: EdgeInsets.only(top: 5),
                    child: TextField(
                      controller: _optionController,
                      decoration: InputDecoration(
                        hintText: "Write an option",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => addOption(index),
                    child: Container(
                      padding: Theme.of(context).insideCardPadding,
                      width: 120,
                      decoration: BoxDecoration(
                        color: questions[index]['options'].length < 4
                            ? PRIMARY_COLOR
                            : Colors.grey,
                        border: Border.all(width: 1.0),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 50),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(border: Border.all(width: 1.0)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(questions.length, (i) {
                                return GestureDetector(
                                  onTap: () {
                                    saveQuestion(_currentIndex);
                                    saveAnswer(_currentIndex);
                                    _pageController.animateToPage(
                                      i,
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(right: 5),
                                    width: 50,
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: i == _currentIndex
                                          ? PRIMARY_COLOR.withOpacity(0.2)
                                          : null,
                                      border: Border.all(
                                        width: 2.0,
                                        color: i == _currentIndex
                                            ? PRIMARY_COLOR
                                            : Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: Text(
                                        (i + 1).toString(),
                                        style: TextStyle(
                                          fontWeight: i == questions.length - 1
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color: i == _currentIndex
                                              ? PRIMARY_COLOR
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed:
                              questions.length < widget.number_of_questions
                              ? addNewQuestion
                              : saveToDatabase,
                          child: Icon(
                            questions.length < widget.number_of_questions
                                ? Icons.add
                                : Icons.save,
                            color: questions.length < widget.number_of_questions
                                ? Colors.white
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // Add a save button for testing
                  ElevatedButton(
                    onPressed: () {
                      saveQuestion(index);
                      saveAnswer(index);
                      saveToDatabase();
                    },
                    child: Text("Save Current Question"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
