import 'package:flutter/material.dart';
import 'package:job_ostad/utils/constants.dart';
import 'package:job_ostad/utils/custom_theme.dart';
import 'package:job_ostad/widgets/examCard.dart';

class Exam extends StatelessWidget {
  const Exam({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: Theme.of(context).defaultPadding,
        child: Column(
          spacing: 10.0,
          children: [
            Examcard(
              desc: "Exam will be appeared on every Friday",
              num_of_question: "20",
              time: "30",
              title: "Weakly model test(Free)",
            ),
            Examcard(
              desc: "Exam will be appeared on every Saturday",
              num_of_question: "20",
              time: "20",
              title: "Bangla 1st Paper",
            ),
          ],
        ),
      ),
    );
  }
}
