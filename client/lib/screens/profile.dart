import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:client/utils/api_settings.dart';
import 'package:client/utils/constants.dart';
import 'package:client/utils/custom_theme.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? username;
  String? email;
  Set<DateTime> submissionDates = {};
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  String _formatDate(DateTime date) => DateFormat('d MMMM, yyyy').format(date);

  bool _isSubmissionDay(DateTime day) {
    final d = DateTime(day.year, day.month, day.day);
    return submissionDates.contains(d);
  }

  Future<void> _fetchData() async {
    final apiSettings = ApiSettings(endPoint: 'user/get-user-stat');
    try {
      final response = await apiSettings.getMethod();

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final message = data['message'];
        final rawTimes = message['submission_times'] as List<dynamic>;

        final parsed = rawTimes
            .where((e) => e != null)
            .map((e) => DateTime.parse(e as String).toLocal())
            .map((d) => DateTime(d.year, d.month, d.day))
            .toSet();

        setState(() {
          username = message['username'] as String?;
          email = message['email'] as String?;
          submissionDates = parsed;
        });
      } else {
        if (mounted) Navigator.pushReplacementNamed(context, '/sign-in');
      }
    } catch (e) {
      debugPrint('Error fetching user stat: $e');
    }
  }

  void logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    Navigator.pushReplacementNamed(context, '/sign-in');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: Theme.of(context).defaultPadding,
        child: Column(
          children: [
            _buildProfileCard(),
            const SizedBox(height: 10),
            _buildCalendarCard(),
            const SizedBox(height: 10),
            ..._buildSettingsList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
      padding: Theme.of(context).insideCardPadding,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: PRIMARY_COLOR),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage('assets/images/user.png'),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username ?? 'Loading...',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(email ?? ''),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarCard() {
    return Container(
      width: double.infinity,
      padding: Theme.of(context).insideCardPadding,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: PRIMARY_COLOR),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          Text(
            '${submissionDates.length} Days stake',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(
                  () => _focusedDay = _focusedDay.subtract(
                    const Duration(days: 7),
                  ),
                ),
              ),
              Text(_formatDate(_focusedDay)),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () => setState(
                  () => _focusedDay = _focusedDay.add(const Duration(days: 7)),
                ),
              ),
            ],
          ),
          TableCalendar(
            firstDay: DateTime(2000),
            lastDay: DateTime(2100),
            focusedDay: _focusedDay,
            calendarFormat: CalendarFormat.week,
            headerVisible: false,
            daysOfWeekVisible: true,
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, _) {
                if (_isSubmissionDay(day)) {
                  return _submissionMarker(day);
                }
                return null;
              },
              todayBuilder: (context, day, _) {
                final base = _todayMarker(day);
                return _isSubmissionDay(day)
                    ? Stack(
                        alignment: Alignment.center,
                        children: [base, _submissionOverlay(day)],
                      )
                    : base;
              },
              selectedBuilder: (context, day, _) => _selectedMarker(day),
            ),
          ),
        ],
      ),
    );
  }

  Widget _submissionMarker(DateTime day) => Container(
    margin: const EdgeInsets.all(5),
    decoration: const BoxDecoration(
      color: Colors.greenAccent,
      shape: BoxShape.circle,
    ),
    alignment: Alignment.center,
    child: Text('${day.day}', style: const TextStyle(color: Colors.black)),
  );

  Widget _submissionOverlay(DateTime day) => Container(
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      border: Border.fromBorderSide(BorderSide(color: Colors.green, width: 2)),
    ),
  );

  Widget _todayMarker(DateTime day) => Container(
    margin: const EdgeInsets.all(5),
    decoration: const BoxDecoration(
      color: Colors.orangeAccent,
      shape: BoxShape.circle,
    ),
    alignment: Alignment.center,
    child: Text('${day.day}', style: const TextStyle(color: Colors.white)),
  );

  Widget _selectedMarker(DateTime day) => Container(
    margin: const EdgeInsets.all(5),
    decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
    alignment: Alignment.center,
    child: Text('${day.day}', style: const TextStyle(color: Colors.white)),
  );

  List<Widget> _buildSettingsList(BuildContext context) {
    final items = [
      {'icon': Icons.edit, 'text': 'Edit Profile'},
      {'icon': Icons.update, 'text': 'Update Package'},
      {'icon': Icons.notifications, 'text': 'Notification'},
      {'icon': Icons.abc, 'text': 'About us'},
      {'icon': Icons.rate_review, 'text': 'App rating'},
      {'icon': Icons.share, 'text': 'App Share'},
      {'icon': Icons.help, 'text': 'Help'},
      {'icon': Icons.logout, 'text': 'Log Out', 'function': logOut},
    ];

    return items.map((item) {
      return GestureDetector(
        onTap: () {
          if (item['text'] == 'Log Out') {
            logOut();
          } else if (item['text'] == 'Edit Profile') {
            Navigator.pushNamed(context, '/profile-info');
          }
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: Theme.of(context).insideCardPadding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(width: 1),
          ),
          child: Row(
            children: [
              Icon(item['icon']! as IconData, color: Colors.black),
              const SizedBox(width: 10),
              Text(
                item['text']! as String,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}
