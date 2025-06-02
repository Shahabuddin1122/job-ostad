import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:admin/utils/api_settings.dart';
import 'package:admin/utils/constants.dart';
import 'package:admin/utils/custom_theme.dart';
import 'package:http/http.dart';

class AddCourse extends StatefulWidget {
  final String? courseId;
  const AddCourse({this.courseId, super.key});

  @override
  State<AddCourse> createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {
  File? imageFile;
  String? selectedValue;
  Map<String, dynamic> originalData = {};
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final keywordsController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.courseId != null) {
      fetchCourseData(widget.courseId!);
    }
  }

  Future<void> fetchCourseData(String courseId) async {
    setState(() {
      isLoading = true;
    });
    try {
      final api = ApiSettings(
        endPoint: 'course/get-course-by-course-id/$courseId',
      ); // Adjust if needed
      final response = await api.getMethod();

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['message'];

        titleController.text = data['title'] ?? '';
        descriptionController.text = data['description'] ?? '';
        keywordsController.text = data['keywords'] ?? '';
        selectedValue = data['category'];
        imageNetworkUrl = data['course_image'];

        // Store original data for change detection
        originalData = {
          'title': titleController.text,
          'description': descriptionController.text,
          'keywords': keywordsController.text,
          'category': selectedValue,
        };

        setState(() {});
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load course data')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error fetching course data: $e')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Hold image url if editing and user hasn't picked new image yet
  String? imageNetworkUrl;

  Future<void> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        imageFile = File(result.files.single.path!);
        imageNetworkUrl =
            null; // Clear network image because user picked new image
      });
    }
  }

  void send() async {
    if ((imageFile == null && imageNetworkUrl == null) ||
        selectedValue == null) {
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

    // Collect changed fields only
    Map<String, String> updatedFields = {};
    if (widget.courseId != null) {
      if (title != originalData['title']) updatedFields['title'] = title;
      if (description != originalData['description']) {
        updatedFields['description'] = description;
      }
      if (keywords != originalData['keywords']) {
        updatedFields['keywords'] = keywords;
      }
      if (selectedValue != originalData['category']) {
        updatedFields['category'] = selectedValue!;
      }
    } else {
      // For add, send all
      updatedFields = {
        'title': title,
        'description': description,
        'keywords': keywords,
        'category': selectedValue!,
      };
    }

    // If no change and no new image, return early
    if (updatedFields.isEmpty && imageFile == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("No changes made")));
      return;
    }

    try {
      late ApiSettings api;
      late StreamedResponse response;

      if (widget.courseId == null) {
        api = ApiSettings(endPoint: 'course/add-course');
        response = await api.postMultipartMethod(
          fields: updatedFields,
          course_image: imageFile,
        );
      } else {
        api = ApiSettings(endPoint: 'course/update-course/${widget.courseId}');
        response = await api.putMultipartMethod(
          fields: updatedFields,
          course_image: imageFile,
        );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Course saved successfully!")));
        Navigator.pop(context);
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
      appBar: AppBar(
        title: Text(widget.courseId == null ? "Add a Course" : "Edit Course"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: Theme.of(context).defaultPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: pickImage,
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
                            child:
                                (imageFile == null && imageNetworkUrl == null)
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.image, size: 45),
                                      Text("Upload Image"),
                                    ],
                                  )
                                : imageFile != null
                                ? Image.file(
                                    imageFile!,
                                    fit: BoxFit.cover,
                                    width: 150,
                                    height: 150,
                                  )
                                : Image.network(
                                    imageNetworkUrl!,
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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: "Enter Title",
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: PRIMARY_COLOR,
                            width: 2,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: PRIMARY_COLOR,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        hintText: "Enter Description",
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: PRIMARY_COLOR,
                            width: 2,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: PRIMARY_COLOR,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Category",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
                            [
                              'BCS',
                              'Bank',
                              'Job Solutions',
                              'Primary',
                              'Admissions',
                              'Others',
                            ].map((String item) {
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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextField(
                      controller: keywordsController,
                      decoration: InputDecoration(
                        hintText: "Write keywords and Press Enter",
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: PRIMARY_COLOR,
                            width: 2,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: PRIMARY_COLOR,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: send,
                            child: Text("Save"),
                          ),
                        ),
                        SizedBox(width: 20),
                        if (widget.courseId == null) ...[
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
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
