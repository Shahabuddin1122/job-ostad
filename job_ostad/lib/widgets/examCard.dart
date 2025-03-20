import 'package:flutter/material.dart';
import 'package:job_ostad/utils/constants.dart';
import 'package:job_ostad/utils/custom_theme.dart';

class Examcard extends StatelessWidget {
  final String title, desc, num_of_question, time;
  const Examcard({
    required this.desc,
    required this.num_of_question,
    required this.time,
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: PRIMARY_COLOR),
        borderRadius: BorderRadius.circular(5.0),
      ),
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
                onPressed: () {
                  Navigator.pushNamed(context, '/exam-script');
                },
                child: Text("Exam"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
