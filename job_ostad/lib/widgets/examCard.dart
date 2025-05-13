import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:job_ostad/utils/api_settings.dart';
import 'package:job_ostad/utils/constants.dart';
import 'package:job_ostad/utils/custom_theme.dart';

class Examcard extends StatelessWidget {
  final String title, desc, num_of_question, time, id, date;
  final bool has_exam_script;
  const Examcard({
    required this.date,
    required this.id,
    required this.has_exam_script,
    required this.desc,
    required this.num_of_question,
    required this.time,
    required this.title,
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

    bool isButtonEnabled() {
      final today = DateTime.now();
      final examDate = DateTime.tryParse(date);
      if (examDate == null) return false;
      final isToday =
          today.year == examDate.year &&
          today.month == examDate.month &&
          today.day == examDate.day;
      return isToday && has_exam_script;
    }

    Future<void> isUserLogin() async {
      ApiSettings apiSettings = ApiSettings(endPoint: 'auth/get-all-user');

      try {
        final response = await apiSettings.getMethod();
        if (response.statusCode == 200) {
          Navigator.pushNamed(context, '/exam-script', arguments: id);
        } else {
          Navigator.pushNamed(context, '/sign-in');
        }
      } catch (e) {}
    }

    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: PRIMARY_COLOR),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(),
              color: PRIMARY_COLOR,
            ),
            child: Text(
              formatDate(date),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            padding: Theme.of(context).insideCardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(desc),
                Text("Number of Questions: $num_of_question"),
                Text("Time: $time min"),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 10.0,
                  children: [
                    ElevatedButton(onPressed: () {}, child: Text("Syllabus")),
                    ElevatedButton(onPressed: () {}, child: Text("Archive")),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          isButtonEnabled() ? SECONDARY_COLOR : DISABLE,
                        ),
                        foregroundColor: WidgetStateProperty.all(
                          isButtonEnabled() ? Colors.white : Colors.black,
                        ),
                      ),
                      onPressed:
                          isButtonEnabled()
                              ? () {
                                isUserLogin();
                              }
                              : null,
                      child: Text("Exam"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
