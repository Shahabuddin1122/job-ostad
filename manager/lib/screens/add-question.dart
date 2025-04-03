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
  String? selectSubjectValue;
  List<Map<String, dynamic>> questions = [
    {'image': null, 'text': '', 'options': <String>[], 'subject': ''},
  ];
  final PageController _pageController = PageController();
  final TextEditingController _optionController = TextEditingController();

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
    setState(() {
      questions.add({
        'image': null,
        'text': '',
        'options': <String>[],
        'subject': '',
      });
    });
    Future.delayed(Duration(milliseconds: 300), () {
      _pageController.animateToPage(
        questions.length - 1,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
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
                      value: selectSubjectValue,
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
                          selectSubjectValue = newValue;
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
                    onChanged: (value) => questions[index]['text'] = value,
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
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewQuestion,
        backgroundColor: PRIMARY_COLOR,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
