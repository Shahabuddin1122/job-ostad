import 'package:flutter/material.dart';
import 'package:client/utils/constants.dart';

class MCQWidget extends StatelessWidget {
  final String question, image;
  final List<String> options;
  final int count;
  final int? selectedIndex;
  final Function(int index) onOptionSelected;

  const MCQWidget({
    required this.image,
    required this.count,
    required this.question,
    required this.options,
    required this.selectedIndex,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    // print('${question} ${selectedIndex}');

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
                  width: double.maxFinite,
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
            return GestureDetector(
              onTap: () => onOptionSelected(index),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: _buildOption(index, options[index], selectedIndex),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildOption(int index, String text, int? selectedIndex) {
    String optionLabel = String.fromCharCode(65 + index);
    bool isSelected = index == selectedIndex;
    return Row(
      children: [
        const SizedBox(width: 20),
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: isSelected ? PRIMARY_COLOR : Colors.transparent,
            borderRadius: BorderRadius.circular(100.0),
            border: Border.all(width: 1.0, color: PRIMARY_COLOR),
          ),
          child: Center(
            child: Text(
              optionLabel,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
        Text(
          text,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
