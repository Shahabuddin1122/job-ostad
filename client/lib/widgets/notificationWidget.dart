import 'package:flutter/material.dart';
import 'package:client/utils/constants.dart';
import 'package:client/utils/custom_theme.dart';

class Notificationwidget extends StatelessWidget {
  final String title, description, date, time;
  const Notificationwidget({
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: Theme.of(context).insideCardPadding,
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: PRIMARY_COLOR),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Row(spacing: 10, children: [Icon(Icons.notifications), Text(title)]),
          Text(description),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                spacing: 10,
                children: [Icon(Icons.calendar_month), Text(date)],
              ),
              Row(spacing: 10, children: [Icon(Icons.schedule), Text(time)]),
            ],
          ),
        ],
      ),
    );
  }
}
