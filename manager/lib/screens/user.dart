import 'package:flutter/material.dart';
import 'package:job_ostad/models/top-user.dart';
import 'package:job_ostad/models/user.dart';
import 'package:job_ostad/utils/custom_theme.dart';

class User extends StatelessWidget {
  const User({super.key});

  @override
  Widget build(BuildContext context) {
    List<UserData> users = [
      UserData(
        name: "John Doe",
        email: "john@example.com",
        number: "123-456-7890",
        subscriptionStatus: "Active",
        courses: "Flutter, Dart",
      ),
      UserData(
        name: "Jane Smith",
        email: "jane@example.com",
        number: "987-654-3210",
        subscriptionStatus: "Inactive",
        courses: "React, JavaScript",
      ),
      UserData(
        name: "Alice Johnson",
        email: "alice@example.com",
        number: "555-123-4567",
        subscriptionStatus: "Active",
        courses: "Python, AI",
      ),
      UserData(
        name: "Bob Brown",
        email: "bob@example.com",
        number: "444-987-6543",
        subscriptionStatus: "Pending",
        courses: "Java, Spring Boot",
      ),
    ];

    List<TopUser> topUsers = [
      TopUser(
        name: "John Doe",
        email: "john@example.com",
        number: "123-456-7890",
        totalCourses: 5,
        lastLogin: "2024-04-01",
      ),
      TopUser(
        name: "Jane Smith",
        email: "jane@example.com",
        number: "987-654-3210",
        totalCourses: 8,
        lastLogin: "2024-04-02",
      ),
      TopUser(
        name: "Alice Johnson",
        email: "alice@example.com",
        number: "555-123-4567",
        totalCourses: 3,
        lastLogin: "2024-03-29",
      ),
      TopUser(
        name: "Bob Brown",
        email: "bob@example.com",
        number: "444-987-6543",
        totalCourses: 6,
        lastLogin: "2024-04-03",
      ),
    ];

    return SingleChildScrollView(
      child: Padding(
        padding: Theme.of(context).defaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Users",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Table(
              border: TableBorder.all(),
              columnWidths: {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1),
                4: FlexColumnWidth(1),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey[300]),
                  children: [
                    for (var heading in [
                      "Name",
                      "Email",
                      "Number",
                      "Subscription Status",
                      "Courses",
                    ])
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            heading,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                ...users.map(
                  (user) => TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            user.name,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            user.email,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            user.number,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            user.subscriptionStatus,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            user.courses,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "Top Users",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Table(
              border: TableBorder.all(),
              columnWidths: {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1),
                4: FlexColumnWidth(1),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey[300]),
                  children: [
                    for (var heading in [
                      "Name",
                      "Email",
                      "Number",
                      "Total Courses",
                      "Last Login",
                    ])
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            heading,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                ...topUsers.map(
                  (user) => TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            user.name,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            user.email,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            user.number,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            user.totalCourses.toString(),
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            user.lastLogin,
                            style: TextStyle(fontSize: 12),
                          ),
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
