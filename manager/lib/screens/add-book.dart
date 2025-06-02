import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:manager/utils/api_settings.dart';
import 'package:manager/utils/constants.dart';
import 'package:manager/utils/custom_theme.dart';

class AddBook extends StatefulWidget {
  const AddBook({super.key});

  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController writterController = TextEditingController();

  String? selectedValue;
  File? imageFile;
  String? pdfPath;
  bool isLoading = false;

  ApiSettings apiSettings = ApiSettings(endPoint: 'book/add-book');

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

  Future<void> pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        pdfPath = result.files.single.path!;
      });
    }
  }

  void uploadInDatabase() async {
    if (titleController.text.isEmpty ||
        descController.text.isEmpty ||
        writterController.text.isEmpty ||
        selectedValue == null ||
        imageFile == null ||
        pdfPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields and upload files.")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final fields = {
        "title": titleController.text,
        "description": descController.text,
        "writer": writterController.text,
        "visibility": selectedValue!,
      };

      final pdfFile = File(pdfPath!);

      final response = await apiSettings.postMultipartMethod(
        fields: fields,
        book_image: imageFile,
        book_pdf: pdfFile,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Book uploaded successfully.")));
        Navigator.pop(context); // Go back to previous screen
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to upload. Status: ${response.statusCode}"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add a Book")),
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
                            width: double.maxFinite,
                            height: 200,
                            child: imageFile == null
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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: "Enter Book Title",
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
                      controller: descController,
                      decoration: InputDecoration(
                        hintText: "Enter Book Description",
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
                      "Writter",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextField(
                      controller: writterController,
                      decoration: InputDecoration(
                        hintText: "Enter Book Writter",
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
                      "Visibility",
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
                          'Select Visibility',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        value: selectedValue,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        underline: SizedBox(),
                        alignment: Alignment.centerLeft,
                        items: ['Manager', 'Paid_User', 'Free_User'].map((
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
                      "Book",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: pickPDF,
                      child: DottedBorder(
                        options: RoundedRectDottedBorderOptions(
                          color: PRIMARY_COLOR,
                          strokeWidth: 3,
                          radius: Radius.circular(5),
                          dashPattern: [10, 5],
                        ),
                        child: Container(
                          width: 150,
                          height: 150,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.import_contacts, size: 45),
                              Text(pdfPath ?? "Upload PDF"),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 80),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: PRIMARY_COLOR,
                        ),
                        onPressed: uploadInDatabase,
                        child: Text("Save"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
