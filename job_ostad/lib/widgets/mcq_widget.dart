import 'package:flutter/material.dart';
import 'package:job_ostad/utils/constants.dart';

class MCQWidget extends StatefulWidget {
  final String question;
  final List<String> options;
  final int count;

  MCQWidget({
    required this.count,
    required this.question,
    required this.options,
  });

  @override
  _MCQWidgetState createState() => _MCQWidgetState();
}

class _MCQWidgetState extends State<MCQWidget> {
  int? _selectedIndex;

  void _selectOption(int index) {
    if (_selectedIndex == null) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.0),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.blue),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.count}. ${widget.question}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          ...List.generate(
            widget.options.length,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: _buildOption(index, widget.options[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(int index, String text) {
    String optionLabel = String.fromCharCode(
      65 + index,
    ); // Convert 0 -> A, 1 -> B, etc.
    return GestureDetector(
      onTap: () => _selectOption(index),
      child: Row(
        children: [
          SizedBox(width: 20),
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color:
                  _selectedIndex == index ? PRIMARY_COLOR : Colors.transparent,
              borderRadius: BorderRadius.circular(100.0),
              border: Border.all(width: 1.0, color: PRIMARY_COLOR),
            ),
            child: Center(
              child: Text(
                optionLabel,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: _selectedIndex == index ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(width: 15),
          Text(
            text,
            style: TextStyle(
              fontWeight:
                  _selectedIndex == index ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
