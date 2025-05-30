import 'package:flutter/material.dart';
import 'package:client/utils/constants.dart';

class CategoryItem extends StatelessWidget {
  final String imagePath, title;
  const CategoryItem({required this.imagePath, required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(width: 2.0, color: PRIMARY_COLOR),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 120,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Image.network(imagePath, fit: BoxFit.fill),
              ),
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                height: 55,
                alignment: Alignment.center,
                child: Text(
                  title.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: title.length > 10 ? 14 : 16,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
