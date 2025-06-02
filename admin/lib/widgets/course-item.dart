import 'package:admin/utils/api_settings.dart';
import 'package:flutter/material.dart';
import 'package:admin/utils/constants.dart';

class CategoryItem extends StatelessWidget {
  final String imagePath, title, courseId;
  final VoidCallback onDelete;
  const CategoryItem({
    required this.imagePath,
    required this.title,
    required this.courseId,
    required this.onDelete,
    super.key,
  });

  Future<void> _deleteCourse(BuildContext context) async {
    ApiSettings apiSettings = ApiSettings(
      endPoint: 'course/delete-course/$courseId',
    );

    try {
      final response = await apiSettings.deleteMethod();
      if (response.statusCode == 200) {
        onDelete();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Course deleted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete course: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

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
                  Navigator.pushNamed(
                    context,
                    '/add-course',
                    arguments: {'courseId': courseId.toString()},
                  );
                } else if (choice == 'delete') {
                  _deleteCourse(context);
                }
              },
              itemBuilder: (BuildContext context) => [
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
