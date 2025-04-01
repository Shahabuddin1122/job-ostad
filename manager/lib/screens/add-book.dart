import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:job_ostad/utils/constants.dart';
import 'package:job_ostad/utils/custom_theme.dart';

class AddBook extends StatefulWidget {
  const AddBook({super.key});

  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  String? selectedValue;
  File? imageFile;
  String? pdfPath;

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
        pdfPath = result.files.single.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add a Book")),
      body: SingleChildScrollView(
        child: Padding(
          padding: Theme.of(context).defaultPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Upload Section
              GestureDetector(
                onTap: pickImage,
                child: Center(
                  child: DottedBorder(
                    color: PRIMARY_COLOR,
                    strokeWidth: 3,
                    radius: Radius.circular(5),
                    dashPattern: [10, 5],
                    child: SizedBox(
                      width: 150,
                      height: 150,
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
                decoration: InputDecoration(
                  hintText: "Enter Book Title",
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
                "Visibility",
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
                  value: selectedValue,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  underline: SizedBox(),
                  alignment: Alignment.centerLeft,
                  items:
                      ['Manager', 'Paid_User', 'Free_User'].map((String item) {
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              // PDF Upload Section
              GestureDetector(
                onTap: pickPDF,
                child: DottedBorder(
                  color: PRIMARY_COLOR,
                  strokeWidth: 3,
                  radius: Radius.circular(5),
                  dashPattern: [10, 5],
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

              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: PRIMARY_COLOR,
                  border: Border.all(width: 0.0),
                ),
                child: ElevatedButton(onPressed: () {}, child: Text("Save")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
