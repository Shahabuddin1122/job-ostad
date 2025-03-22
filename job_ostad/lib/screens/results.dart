import 'package:flutter/material.dart';
import 'package:job_ostad/utils/constants.dart';
import 'package:job_ostad/utils/custom_theme.dart';

class Results extends StatelessWidget {
  const Results({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: Theme.of(context).defaultPadding,
        child: Column(
          spacing: 10.0,
          children: [
            Container(
              padding: Theme.of(context).insideCardPadding,
              width: double.maxFinite,
              decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: PRIMARY_COLOR),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Active Package: 47th BCS Crash Course",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text("20 days left"),
                  ),
                ],
              ),
            ),
            Container(
              padding: Theme.of(context).insideCardPadding,
              width: double.maxFinite,
              decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: PRIMARY_COLOR),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                "Merit position: 213",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: Theme.of(context).insideCardPadding,
              width: double.maxFinite,
              decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: PRIMARY_COLOR),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  Container(height: 200, color: PRIMARY_COLOR),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Exam Apeared: 5",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Total Correct Answered: 234(67%)",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Total Wrong Answered: 45(33%)",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text("Total mark: 210", style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: Theme.of(context).insideCardPadding,
              width: double.maxFinite,
              decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: PRIMARY_COLOR),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Exam Details",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Weakly model test(Free)",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                  Text(
                    "Bangla First Paper(1st part)",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                  Text(
                    "English first paper(2ed part)",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
