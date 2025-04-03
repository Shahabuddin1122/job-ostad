import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:job_ostad/utils/constants.dart';
import 'package:job_ostad/utils/custom_theme.dart';

class AddQuestion extends StatefulWidget {
  const AddQuestion({super.key});

  @override
  State<AddQuestion> createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  List<Map<String, dynamic>> questions = [
    {'image': null, 'text': '', 'options': <String>[], 'subject': null},
  ];

  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _optionController = TextEditingController();
  final TextEditingController _questionController = TextEditingController();
  int _currentIndex = 0;

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
    if (questions.length < 20) {
      setState(() {
        questions.add({
          'image': null,
          'text': '',
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
    // This ensures all data is saved when navigating away from a question
    setState(() {
      questions[index]['text'] = _questionController.text;
    });
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
          }
          setState(() {
            _currentIndex = index;
            // Update controllers with current question data
            _questionController.text = questions[index]['text'] ?? '';
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
                        color: PRIMARY_COLOR,
                        strokeWidth: 3,
                        radius: Radius.circular(5),
                        dashPattern: [10, 5],
                        child: SizedBox(
                          width: double.infinity,
                          height: 200,
                          child:
                              questions[index]['image'] == null
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
                      items:
                          ['Bangla', 'English', 'Math'].map((String item) {
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
                      questions[index]['text'] = value;
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
                    "Options",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Column(
                    children:
                        questions[index]['options'].map<Widget>((option) {
                          return Container(
                            margin: EdgeInsets.only(top: 5),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: PRIMARY_COLOR,
                                width: 1,
                              ),
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
                        color:
                            questions[index]['options'].length < 4
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
                                      color:
                                          i == _currentIndex
                                              ? PRIMARY_COLOR.withOpacity(0.2)
                                              : null,
                                      border: Border.all(
                                        width: 2.0,
                                        color:
                                            i == _currentIndex
                                                ? PRIMARY_COLOR
                                                : Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: Text(
                                        (i + 1).toString(),
                                        style: TextStyle(
                                          fontWeight:
                                              i == questions.length - 1
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                          color:
                                              i == _currentIndex
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
                              questions.length < 20 ? addNewQuestion : null,
                          child: Icon(
                            questions.length < 20 ? Icons.add : Icons.save,
                            color:
                                questions.length < 20
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
                      print(
                        questions,
                      ); // For debugging - check if data is saved
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
