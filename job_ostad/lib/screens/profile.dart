import 'package:flutter/material.dart';
import 'package:job_ostad/utils/constants.dart';
import 'package:job_ostad/utils/custom_theme.dart';
import 'package:table_calendar/table_calendar.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: Theme.of(context).defaultPadding,
        child: Column(
          spacing: 10.0,
          children: [
            Container(
              width: double.infinity,
              padding: Theme.of(context).insideCardPadding,
              decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: PRIMARY_COLOR),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                spacing: 10.0,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage("assets/images/me.jpeg"),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Shahabuddin Akhon",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("Student@BCS Crash Course"),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: Theme.of(context).insideCardPadding,
              decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: PRIMARY_COLOR),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                spacing: 10.0,
                children: [
                  Text(
                    "20 Days stake",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.arrow_back),
                      Text("20 March, 2012"),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
                  TableCalendar(
                    firstDay: DateTime(2000),
                    lastDay: DateTime(2100),
                    focusedDay: DateTime.now(),
                    calendarFormat: CalendarFormat.week,
                    headerVisible: false,
                    daysOfWeekVisible: true,
                    selectedDayPredicate:
                        (day) => isSameDay(day, DateTime.now()),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Column(
              spacing: 10,
              children: [
                Container(
                  padding: Theme.of(context).insideCardPadding,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.grey,
                  ),
                  child: Row(
                    spacing: 10.0,
                    children: [
                      Icon(Icons.edit, color: Colors.white),
                      Text(
                        "Edit Profile",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: Theme.of(context).insideCardPadding,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.grey,
                  ),
                  child: Row(
                    spacing: 10.0,
                    children: [
                      Icon(Icons.update, color: Colors.white),
                      Text(
                        "Update Package",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: Theme.of(context).insideCardPadding,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.grey,
                  ),
                  child: Row(
                    spacing: 10.0,
                    children: [
                      Icon(Icons.notifications, color: Colors.white),
                      Text(
                        "Notification",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: Theme.of(context).insideCardPadding,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.grey,
                  ),
                  child: Row(
                    spacing: 10.0,
                    children: [
                      Icon(Icons.abc, color: Colors.white),
                      Text(
                        "About us",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: Theme.of(context).insideCardPadding,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.grey,
                  ),
                  child: Row(
                    spacing: 10.0,
                    children: [
                      Icon(Icons.help, color: Colors.white),
                      Text(
                        "Help",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
