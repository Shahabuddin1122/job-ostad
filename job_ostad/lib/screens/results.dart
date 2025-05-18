import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:job_ostad/utils/api_settings.dart';
import 'package:job_ostad/utils/constants.dart';
import 'package:job_ostad/utils/custom_theme.dart';

class Results extends StatefulWidget {
  const Results({super.key});

  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  int totalExams = 0;
  int totalCorrect = 0;
  int totalWrong = 0;
  List<dynamic> results = [];

  @override
  void initState() {
    super.initState();
    getResults();
  }

  void getResults() async {
    try {
      ApiSettings apiSettings = ApiSettings(endPoint: 'user/get-user-result');
      final response = await apiSettings.getMethod();

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        final resultData = json['data'];
        setState(() {
          totalExams = resultData['total_exams'] ?? 0;
          totalCorrect = resultData['total_correct'] ?? 0;
          totalWrong = resultData['total_wrong'] ?? 0;
          results = resultData['results'] ?? [];
        });
      } else {
        print("Failed to fetch result. Status code: ${response.statusCode}");
        Navigator.pushReplacementNamed(context, '/sign-in');
      }
    } catch (e) {
      print("Error in getResults: $e");
      Navigator.pushReplacementNamed(context, '/sign-in');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate percentages for pie chart
    double totalAnswers = totalCorrect.toDouble() + totalWrong.toDouble();
    double correctPercentage =
        totalAnswers > 0 ? (totalCorrect / totalAnswers * 100) : 0;
    double wrongPercentage =
        totalAnswers > 0 ? (totalWrong / totalAnswers * 100) : 0;

    return SingleChildScrollView(
      child: Padding(
        padding: Theme.of(context).defaultPadding,
        child: Column(
          spacing: 10.0,
          children: [
            // Active Package Section (Static as per original)
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
            // Merit Position (Static as no data in API response)
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
            // Pie Chart and Summary Section
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
                  SizedBox(
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            value: correctPercentage,
                            color: Colors.green,
                            title: '${correctPercentage.toStringAsFixed(0)}%',
                            radius: 50,
                            titleStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          PieChartSectionData(
                            value: wrongPercentage,
                            color: Colors.red,
                            title: '${wrongPercentage.toStringAsFixed(0)}%',
                            radius: 50,
                            titleStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Exam Appeared: $totalExams",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Total Correct Answered: $totalCorrect (${correctPercentage.toStringAsFixed(0)}%)",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Total Wrong Answered: $totalWrong (${wrongPercentage.toStringAsFixed(0)}%)",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Total mark: ${results.isNotEmpty ? results[0]['score'] : 0}",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Exam Details Section
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
                  SizedBox(
                    height: 200,
                    child: BarChart(
                      BarChartData(
                        barGroups:
                            results.asMap().entries.map((entry) {
                              int index = entry.key;
                              var result = entry.value;
                              double score =
                                  double.tryParse(result['score'].toString()) ??
                                  0;
                              return BarChartGroupData(
                                x: index + 1,
                                barRods: [
                                  BarChartRodData(
                                    toY: score,
                                    color:
                                        score >= 80
                                            ? Colors.green
                                            : score >= 60
                                            ? Colors.blue
                                            : Colors.red,
                                  ),
                                ],
                              );
                            }).toList(),
                        titlesData: FlTitlesData(
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: true),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                int index = value.toInt() - 1;
                                if (index >= 0 && index < results.length) {
                                  return Text(results[index]['title']);
                                }
                                return Text('');
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Display exam titles from results
                  ...results
                      .map(
                        (result) => TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/answer-script',
                              arguments: result['result_id'].toString(),
                            );
                          },
                          child: Text(
                            result['title'],
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 16,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
