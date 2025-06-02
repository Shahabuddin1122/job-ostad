import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:admin/utils/constants.dart';
import 'package:admin/utils/custom_theme.dart';

class Overview extends StatefulWidget {
  const Overview({super.key});

  @override
  State<Overview> createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  String? selectedValue;
  List<String> items = ['Daily', 'Weakly', 'Monthly', 'Yearly'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: Theme.of(context).defaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: Theme.of(context).insideCardPadding,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(width: 1.0, color: PRIMARY_COLOR),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.person),
                            SizedBox(width: 10),
                            Text("Total Users"),
                          ],
                        ),
                        Text(
                          "212",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text(
                              "2%",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text("per day", style: TextStyle(fontSize: 16)),
                          ],
                        ),
                        SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 1.0, color: Colors.black),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: DropdownButton<String>(
                            hint: Text(
                              'Select',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            value: selectedValue,
                            style: TextStyle(color: Colors.black, fontSize: 16),
                            isDense: true,
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            underline: SizedBox(),
                            alignment: Alignment.centerLeft,
                            items: items.map((String item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Text(item),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedValue = newValue;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: SizedBox(
                      width: 300,
                      height: 220,
                      child: Column(
                        children: [
                          Text(
                            "Users Over Time",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              _buildLegendItem(Colors.blue, "Free Users"),
                              SizedBox(width: 10),
                              _buildLegendItem(
                                Colors.lightBlueAccent,
                                "Paid Users",
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Expanded(
                            child: BarChart(
                              BarChartData(
                                barGroups: _getBarGroups(),
                                gridData: FlGridData(show: false),
                                borderData: FlBorderData(show: true),
                                titlesData: FlTitlesData(
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 20,
                                      getTitlesWidget: (value, meta) => Text(
                                        "${value.toInt()}",
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ),
                                  ),
                                  topTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  rightTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        List<String> days = [
                                          "Sat",
                                          "Sun",
                                          "Mon",
                                          "Tue",
                                          "Wed",
                                          "Thu",
                                          "Fri",
                                        ];
                                        return Text(
                                          days[value.toInt()],
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: Theme.of(context).insideCardPadding,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(width: 1.0, color: PRIMARY_COLOR),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.money),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "Total Revenues",
                                softWrap: true,
                                maxLines: 2,
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "31,562",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text(
                              "2%",
                              style: TextStyle(color: Colors.red, fontSize: 16),
                            ),
                            SizedBox(width: 10),
                            Text("per day", style: TextStyle(fontSize: 16)),
                          ],
                        ),
                        SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 1.0, color: Colors.black),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: DropdownButton<String>(
                            hint: Text(
                              'Select',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            value: selectedValue,
                            style: TextStyle(color: Colors.black, fontSize: 16),
                            isDense: true,
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            underline: SizedBox(),
                            alignment: Alignment.centerLeft,
                            items: items.map((String item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Text(item),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedValue = newValue;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: SizedBox(
                      width: 300,
                      height: 220,
                      child: Column(
                        children: [
                          Text(
                            "Revenues Over Time",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Expanded(
                            child: BarChart(
                              BarChartData(
                                barGroups: _getRevenues(),
                                gridData: FlGridData(show: false),
                                borderData: FlBorderData(show: true),
                                titlesData: FlTitlesData(
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 20,
                                      getTitlesWidget: (value, meta) => Text(
                                        "${value.toInt()}",
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ),
                                  ),
                                  topTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  rightTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        List<String> days = [
                                          "Sat",
                                          "Sun",
                                          "Mon",
                                          "Tue",
                                          "Wed",
                                          "Thu",
                                          "Fri",
                                        ];
                                        return Text(
                                          days[value.toInt()],
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Popular Courses",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Table(
              border: TableBorder.all(),
              columnWidths: {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey[300]),

                  children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Course Title",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Number of Enrollment",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Total Revenue",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("47th BCS"),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("108"),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("৳ 10,012"),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Bank Preparation"),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("20"),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("৳ 6710"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(width: 12, height: 12, color: color),
        SizedBox(width: 5),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  List<BarChartGroupData> _getBarGroups() {
    List<double> freeUsers = [5, 6, 8, 7, 6, 7, 6];
    List<double> paidUsers = [3, 2, 4, 3, 2, 3, 4];

    return List.generate(7, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(toY: freeUsers[index], color: Colors.blue, width: 3),
          BarChartRodData(
            toY: freeUsers[index] + paidUsers[index],
            color: Colors.lightBlueAccent,
            width: 3,
          ),
        ],
      );
    });
  }

  List<BarChartGroupData> _getRevenues() {
    List<double> revenues = [5, 6, 8, 7, 6, 7, 6];

    return List.generate(7, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: revenues[index],
            color: Colors.blue,
            width: 10,
            borderRadius: BorderRadius.circular(2),
          ),
        ],
      );
    });
  }
}
