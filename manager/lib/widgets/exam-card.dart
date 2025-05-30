import 'package:flutter/material.dart';
import 'package:job_ostad/utils/constants.dart';
import 'package:job_ostad/utils/custom_theme.dart';
import 'package:intl/intl.dart';

class Examcard extends StatelessWidget {
  final String id, title, desc, time, date;
  final int num_of_question;
  final bool has_exam_script;
  const Examcard({
    required this.id,
    required this.desc,
    required this.num_of_question,
    required this.time,
    required this.title,
    required this.has_exam_script,
    required this.date,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String formatDate(String dateString) {
      try {
        final DateTime parsedDate = DateTime.parse(dateString);
        final String formatted = DateFormat(
          'd MMMM y, EEEE',
        ).format(parsedDate);
        return formatted;
      } catch (e) {
        return dateString;
      }
    }

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formatDate(date),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            SizedBox(height: 10),
            Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: PRIMARY_COLOR),
                borderRadius: BorderRadius.circular(5.0),
              ),
              padding: Theme.of(context).insideCardPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Text(desc),
                  Text("Number of Questions: ${num_of_question.toString()}"),
                  Text("Time: $time min"),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    spacing: 10.0,
                    children: [
                      has_exam_script
                          ? ElevatedButton(
                            onPressed: () {},
                            child: Text("Update"),
                          )
                          : Text(''),
                      ElevatedButton(
                        onPressed: () {
                          has_exam_script
                              ? Navigator.pushNamed(
                                context,
                                '/question-paper',
                                arguments: id,
                              )
                              : Navigator.pushNamed(
                                context,
                                '/add-question',
                                arguments: [id, num_of_question],
                              );
                        },
                        child: Text(has_exam_script ? "View" : "Add Question"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(right: 10, top: 40, child: Icon(Icons.close)),
      ],
    );
  }
}
