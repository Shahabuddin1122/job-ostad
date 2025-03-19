import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:job_ostad/utils/constants.dart';
import 'package:job_ostad/utils/custom_theme.dart';
import 'package:job_ostad/widgets/categoryItem.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> imageList = [
      'assets/images/banner_1.png',
      'assets/images/banner_2.png',
      'assets/images/banner_2.png',
    ];

    // List of category names
    final List<String> categories = [
      "BCS",
      "Job Solutions",
      "Admissions",
      "Bank",
      "Primary",
      "Others",
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          CarouselSlider(
            options: CarouselOptions(
              height: 200.0,
              autoPlay: true,
              enlargeCenterPage: true,
              enableInfiniteScroll: true,
              autoPlayInterval: const Duration(seconds: 3),
            ),
            items:
                imageList.map((imagePath) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 1.0),
                      image: DecorationImage(
                        image: AssetImage(imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }).toList(),
          ),

          const SizedBox(height: 20),

          Padding(
            padding: Theme.of(context).defaultPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Categories",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 10),

                Wrap(
                  spacing: 20,
                  runSpacing: 10,
                  children:
                      categories.map((category) {
                        return CategoryCard(category: category);
                      }).toList(),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Treding Quiz",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "See all",
                      style: TextStyle(color: SECONDARY_BACKGROUND),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    final items = [
                      CategoryItem(
                        imagePath:
                            "assets/images/Lamp, books and objects for studying.png",
                        title: "47th BCS CRASH COURSE",
                      ),
                      CategoryItem(
                        imagePath:
                            "assets/images/Young woman doing her homework.png",
                        title: "BANK PROSTUTI",
                      ),
                    ];
                    return items[index];
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Top Study Group",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "See all",
                      style: TextStyle(color: SECONDARY_BACKGROUND),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    final items = [
                      CategoryItem(
                        imagePath:
                            "assets/images/Back to school, items for studying.png",
                        title: "48th BCS",
                      ),
                      CategoryItem(
                        imagePath:
                            "assets/images/notebook with glasses and pencil.png",
                        title: "HSE 2025",
                      ),
                    ];
                    return items[index];
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String category;

  const CategoryCard({required this.category, super.key});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.47,
      child: Container(
        padding: Theme.of(context).insideCardPadding,
        decoration: BoxDecoration(
          color: SECONDARY_COLOR,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(category, style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
