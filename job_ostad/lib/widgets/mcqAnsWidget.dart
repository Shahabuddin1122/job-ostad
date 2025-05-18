import 'package:flutter/material.dart';
import 'package:job_ostad/utils/constants.dart';
import 'package:job_ostad/utils/custom_theme.dart';

class Mcqanswidget extends StatelessWidget {
  final String question, image, selectedOption, correctAnswer;
  final List<String> options;
  final int count;

  const Mcqanswidget({
    required this.image,
    required this.count,
    required this.question,
    required this.options,
    required this.selectedOption,
    required this.correctAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.blue),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$count. $question',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          image.isNotEmpty
              ? Container(
                width: double.infinity,
                height: 200,
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(image, fit: BoxFit.contain),
                ),
              )
              : const SizedBox.shrink(),
          const SizedBox(height: 10),
          ...List.generate(options.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: _buildOption(index, options[index]),
            );
          }),
          const SizedBox(height: 10),
          Container(
            width: double.maxFinite,
            padding: Theme.of(context).insideCardPadding,
            decoration: BoxDecoration(
              color: Colors.lightGreenAccent.withAlpha(50),
              border: Border.all(width: 1.0, color: Colors.lightGreenAccent),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Answer:\n$correctAnswer',
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(int index, String text) {
    String optionLabel = String.fromCharCode(65 + index);
    bool isSelected = (text == selectedOption);
    bool isCorrect = (text == correctAnswer);

    Color? bgColor;
    Color textColor = Colors.black;

    if (isCorrect && isSelected) {
      bgColor = Colors.green;
      textColor = Colors.white;
    } else if (isSelected && !isCorrect) {
      bgColor = Colors.red;
      textColor = Colors.white;
    }

    return Row(
      children: [
        const SizedBox(width: 20),
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: bgColor ?? Colors.transparent,
            borderRadius: BorderRadius.circular(100.0),
            border: Border.all(width: 1.0, color: bgColor ?? PRIMARY_COLOR),
          ),
          child: Center(
            child: Text(
              optionLabel,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: bgColor ?? Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
