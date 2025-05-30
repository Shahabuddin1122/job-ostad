import 'package:flutter/material.dart';
import 'package:client/utils/custom_theme.dart';
import 'package:client/widgets/notificationWidget.dart';

class Overview extends StatelessWidget {
  const Overview({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: Theme.of(context).defaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10.0,
          children: [
            Notificationwidget(
              title: "Exam Reminder",
              description: 'Your Math Final Exam starts tomorrow at 10:00 AM.',
              date: "May 20, 2025",
              time: "10: 30 AM",
            ),
            Notificationwidget(
              title: "Exam Reminder",
              description: 'Your Math Final Exam starts tomorrow at 10:00 AM.',
              date: "May 20, 2025",
              time: "10: 30 AM",
            ),
          ],
        ),
      ),
    );
  }
}
