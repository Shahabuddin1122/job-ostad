import 'package:flutter/material.dart';
import 'package:job_ostad/utils/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoryItem extends StatelessWidget {
  final String imagePath, title;
  const CategoryItem({required this.imagePath, required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Stack(
        children: [
          Container(
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
          Positioned(
            top: 4,
            right: 4,
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.black),
              color: Colors.white,
              onSelected: (String choice) {
                if (choice == 'edit') {
                  // Handle edit
                  print("Edit selected");
                } else if (choice == 'delete') {
                  // Handle delete
                  print("Delete selected");
                } else if (choice == 'view') {
                  // Handle view
                  print("View selected");
                }
              },
              itemBuilder:
                  (BuildContext context) => [
                    const PopupMenuItem(
                      value: 'view',
                      child: Row(
                        children: [
                          Icon(Icons.visibility, color: Colors.black),
                          SizedBox(width: 8),
                          Text("View"),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: Colors.blue),
                          SizedBox(width: 8),
                          Text("Edit"),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text("Delete"),
                        ],
                      ),
                    ),
                  ],
            ),
          ),
        ],
      ),
    );
  }
}
