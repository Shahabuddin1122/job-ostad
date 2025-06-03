import 'dart:convert';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:admin/utils/constants.dart';
import 'package:admin/utils/custom_theme.dart';
import 'package:admin/utils/api_settings.dart';

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
      'id': null,
      'image': null,
      'question': '',
      'answer': '',
      'options': <String>[],
      'subject': null,
    },
  ];
  String? title;
  int? totalTime;
  int? numberOfQuestions;
  bool _hasFetchedQuestions = false; // Track if questions were fetched

  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _optionController = TextEditingController();
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  int _currentIndex = 0;
  bool _isSubmitting = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    _optionController.dispose();
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  Future<void> fetchQuestions() async {
    setState(() {
      _isLoading = true;
    });
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

          questions.clear();
          if (data.isNotEmpty) {
            _hasFetchedQuestions = true; // Mark that questions were fetched
            for (var item in data) {
              questions.add({
                'id': item['id'],
                'question': item['question'] ?? '',
                'answer': item['answer'] ?? '',
                'options': List<String>.from(item['options'] ?? []),
                'subject': item['subject'] ?? 'General',
                'image': item['image'],
              });
            }
            if (questions.isNotEmpty) {
              _currentIndex = 0;
              _questionController.text = questions[0]['question'] ?? '';
              _answerController.text = questions[0]['answer'] ?? '';
              if (questions[0]['options'] == null) {
                questions[0]['options'] = <String>[];
              }
            }
          } else {
            _hasFetchedQuestions = false; // No questions fetched
          }
          _isLoading = false;
        });
      } else {
        setState(() {
          _hasFetchedQuestions = false; // Assume no questions if API fails
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _hasFetchedQuestions = false;
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error fetching questions: $e")));
    }
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
        (questions[index]['options']?.length ?? 0) < 4) {
      setState(() {
        if (questions[index]['options'] == null) {
          questions[index]['options'] = <String>[];
        }
        questions[index]['options'].add(_optionController.text);
        _optionController.clear();
      });
    }
  }

  void removeOption(int index, String option) {
    setState(() {
      if (questions[index]['options'] != null) {
        questions[index]['options'].remove(option);
      }
    });
  }

  void addNewQuestion() {
    if (questions.length < widget.number_of_questions) {
      setState(() {
        questions.add({
          'id': null,
          'image': null,
          'question': '',
          'answer': '',
          'options': <String>[],
          'subject': null,
        });
        _currentIndex = questions.length - 1;
        _questionController.clear();
        _answerController.clear();
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

  Future<void> saveToDatabase() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      // Prepare questions data
      List<Map<String, dynamic>> questionsData = questions.map((q) {
        return {
          'id': q['id'],
          'question': q['question'],
          'answer': q['answer'],
          'options': q['options'] ?? <String>[],
          'subject': q['subject'],
        };
      }).toList();

      // Collect images
      List<File> questionImages = questions
          .where((q) => q['image'] != null && q['image'] is File)
          .map((q) => q['image'] as File)
          .toList();

      // Decide whether to create or update based on _hasFetchedQuestions
      ApiSettings apiSettings;
      String method;
      int expectedStatusCode;

      if (_hasFetchedQuestions) {
        // Update questions (existing and new) using PUT
        apiSettings = ApiSettings(endPoint: 'exam/update-question');
        method = 'PUT';
        expectedStatusCode = 200;
      } else {
        // Create new questions using POST
        apiSettings = ApiSettings(endPoint: 'exam/create-question');
        method = 'POST';
        expectedStatusCode = 201;
      }

      // Prepare fields
      Map<String, String> fields = {
        'quiz_id': widget.id,
        'questions': jsonEncode(questionsData),
      };

      // Use first image (as per cURL)
      File? imageFile = questionImages.isNotEmpty ? questionImages.first : null;

      // Send request
      final response = await (method == 'POST'
          ? apiSettings.postMultipartMethod(
              fields: fields,
              book_image: imageFile,
            )
          : apiSettings.putMultipartMethod(
              fields: fields,
              book_image: imageFile,
            ));

      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == expectedStatusCode) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Questions saved successfully!")),
        );
        setState(() {
          _isSubmitting = false;
        });
        Navigator.popAndPushNamed(context, '/');
      } else {
        throw Exception(
          'Failed to ${method == 'POST' ? 'create' : 'update'} questions: $responseBody',
        );
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title ?? "Questions")),
      body: Stack(
        children: [
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : PageView.builder(
                  controller: _pageController,
                  itemCount: questions.length,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index) {
                    if (_currentIndex < questions.length) {
                      saveQuestion(_currentIndex);
                      saveAnswer(_currentIndex);
                    }
                    setState(() {
                      _currentIndex = index;
                      _questionController.text =
                          questions[index]['question'] ?? '';
                      _answerController.text = questions[index]['answer'] ?? '';
                      if (questions[index]['options'] == null) {
                        questions[index]['options'] = <String>[];
                      }
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.image, size: 45),
                                              Text("Upload Image"),
                                            ],
                                          )
                                        : questions[index]['image'] is File
                                        ? Image.file(
                                            questions[index]['image'],
                                            fit: BoxFit.cover,
                                            width: 150,
                                            height: 150,
                                          )
                                        : Image.network(
                                            questions[index]['image'],
                                            fit: BoxFit.cover,
                                            width: 150,
                                            height: 150,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.error,
                                                        size: 45,
                                                      ),
                                                      Text(
                                                        "Image not available",
                                                      ),
                                                    ],
                                                  );
                                                },
                                          ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Subject",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 2.0,
                                    color: PRIMARY_COLOR,
                                  ),
                                ),
                              ),
                              child: DropdownButton<String>(
                                isExpanded: true,
                                hint: Text(
                                  'Select Subject',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                value: questions[index]['subject'],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                underline: SizedBox(),
                                alignment: Alignment.centerLeft,
                                items:
                                    [
                                      'Bangla Language and Literature',
                                      'English Language and Literature',
                                      'Bangladesh Affairs',
                                      'International Affairs',
                                      'Geography (Bangladesh and World), Environment and Disaster Management',
                                      'General Science',
                                      'Computer and Information Technology',
                                      'Mathematical Reasoning',
                                      'Mental Ability',
                                      'Ethics, Values and Good Governance',
                                      'General',
                                    ].map((String item) {
                                      return DropdownMenuItem<String>(
                                        value: item,
                                        child: Container(
                                          width: double.infinity,
                                          child: Text(
                                            item,
                                            softWrap: true,
                                            overflow: TextOverflow.visible,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
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
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextField(
                              controller: _questionController,
                              onChanged: (value) {
                                questions[index]['question'] = value;
                              },
                              decoration: InputDecoration(
                                hintText: "Enter Question",
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
                              "Answer",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextField(
                              controller: _answerController,
                              onChanged: (value) {
                                questions[index]['answer'] = value;
                              },
                              decoration: InputDecoration(
                                hintText: "Enter Answer",
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
                              "Options",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Column(
                              children:
                                  (questions[index]['options'] ?? <String>[])
                                      .map<Widget>((option) {
                                        return Container(
                                          margin: EdgeInsets.only(top: 5),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: PRIMARY_COLOR,
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(child: Text(option)),
                                              IconButton(
                                                icon: Icon(
                                                  Icons.close,
                                                  color: Colors.red,
                                                ),
                                                onPressed: () =>
                                                    removeOption(index, option),
                                              ),
                                            ],
                                          ),
                                        );
                                      })
                                      .toList(),
                            ),
                            SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: PRIMARY_COLOR,
                                  width: 2,
                                ),
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
                                      (questions[index]['options']?.length ??
                                              0) <
                                          4
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
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(width: 1.0),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: SingleChildScrollView(
                                      controller: _scrollController,
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: List.generate(
                                          questions.length,
                                          (i) {
                                            return GestureDetector(
                                              onTap: () {
                                                saveQuestion(_currentIndex);
                                                saveAnswer(_currentIndex);
                                                _pageController.animateToPage(
                                                  i,
                                                  duration: Duration(
                                                    milliseconds: 300,
                                                  ),
                                                  curve: Curves.easeInOut,
                                                );
                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                  right: 5,
                                                ),
                                                width: 50,
                                                padding: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: i == _currentIndex
                                                      ? PRIMARY_COLOR
                                                            .withOpacity(0.2)
                                                      : null,
                                                  border: Border.all(
                                                    width: 2.0,
                                                    color: i == _currentIndex
                                                        ? PRIMARY_COLOR
                                                        : Colors.grey,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    (i + 1).toString(),
                                                    style: TextStyle(
                                                      fontWeight:
                                                          i ==
                                                              questions.length -
                                                                  1
                                                          ? FontWeight.bold
                                                          : FontWeight.normal,
                                                      color: i == _currentIndex
                                                          ? Colors.black
                                                          : Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed:
                                        questions.length <
                                            (numberOfQuestions ??
                                                widget.number_of_questions)
                                        ? addNewQuestion
                                        : saveToDatabase,
                                    child: Icon(
                                      (questions.length <
                                                  (numberOfQuestions ??
                                                      widget
                                                          .number_of_questions)
                                              ? Icons.add
                                              : Colors.black)
                                          as IconData?,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                saveQuestion(index);
                                saveAnswer(index);
                                saveToDatabase();
                              },
                              child: Text(
                                questions[index]['id'] == null
                                    ? "Save Current Question"
                                    : "Update Current Question",
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
          if (_isSubmitting)
            Positioned.fill(
              child: Container(
                color: Colors.black.withAlpha(125),
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }
}
