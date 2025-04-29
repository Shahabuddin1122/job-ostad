import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:job_ostad/utils/api_settings.dart';
import 'package:job_ostad/utils/constants.dart';
import 'package:job_ostad/utils/custom_theme.dart';

class AddCourse extends StatefulWidget {
  const AddCourse({super.key});

  @override
  State<AddCourse> createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {
  File? imageFile;
  String? selectedValue;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final keywordsController = TextEditingController();

  Future<void> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        imageFile = File(result.files.single.path!);
      });
    }
  }

  void send() async {
    if (imageFile == null || selectedValue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Image and category must be selected")),
      );
      return;
    }

    final String title = titleController.text.trim();
    final String description = descriptionController.text.trim();
    final String keywords = keywordsController.text.trim();

    if (title.isEmpty || description.isEmpty || keywords.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please fill in all fields")));
      return;
    }

    try {
      final api = ApiSettings(endPoint: 'course/add-course');

      final response = await api.postMultipartMethod(
        fields: {
          'title': title,
          'description': description,
          'category': selectedValue!,
          'keywords': keywords,
        },
        course_image: imageFile,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Course added successfully!")));
      } else {
        final resStr = await response.stream.bytesToString();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed: ${response.statusCode} - $resStr")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add a Course")),
      body: SingleChildScrollView(
        child: Padding(
          padding: Theme.of(context).defaultPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: pickImage,
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
                          imageFile == null
                              ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.image, size: 45),
                                  Text("Upload Image"),
                                ],
                              )
                              : Image.file(
                                imageFile!,
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
                controller: descriptionController,
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
                "Category",
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
                    'Select a Category',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  value: selectedValue,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  underline: SizedBox(),
                  alignment: Alignment.centerLeft,
                  items:
                      ['BCS', 'Bank', 'Job Preparation', 'Primary'].map((
                        String item,
                      ) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValue = newValue;
                    });
                  },
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
              SizedBox(height: 50),
              Row(
                spacing: 20,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        send();
                        Navigator.pop(context);
                      },
                      child: Text("Save"),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        send();
                        Navigator.popAndPushNamed(context, '/add-quiz');
                      },
                      child: Text("Add Quiz"),
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
