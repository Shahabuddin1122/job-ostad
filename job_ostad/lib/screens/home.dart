import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:job_ostad/utils/constants.dart';
import 'package:job_ostad/utils/custom_theme.dart';
import 'package:job_ostad/widgets/categoryItem.dart';

class Home extends StatelessWidget {
  final Function(String) onTextClicked;
  const Home({required this.onTextClicked, super.key});

  @override
  Widget build(BuildContext context) {
    // List of category names
    final List<String> categories = [
      "BCS",
      "Job Solutions",
      "Admissions",
      "Bank",
      "Primary",
      "Others",
    ];

    final List<Map<String, String>> banners = [
      {
        "image": "assets/images/isometric teacher's desk with blackboard.png",
        "title": "শিক্ষকের সহায়ক টুলস",
        "subtitle": "ব্ল্যাকবোর্ড, পাঠ পরিকল্পনা ও শিক্ষণ উপকরণ",
        "buttonText": "আরও জানুন",
      },
      {
        "image": "assets/images/Online education with notepad.png",
        "title": "অনলাইন শিক্ষা প্ল্যাটফর্ম",
        "subtitle": "নোটপ্যাড ব্যবহার করে সহজলভ্য শিক্ষা",
        "buttonText": "শিখতে শুরু করুন",
      },
      {
        "image": "assets/images/Task management and planner organizing.png",
        "title": "কর্মপরিকল্পনা ও টাস্ক ম্যানেজমেন্ট",
        "subtitle": "আপনার অধ্যয়ন পরিকল্পনা সুসংগঠিত করুন",
        "buttonText": "পরিকল্পনা তৈরি করুন",
      },
      {
        "image": "assets/images/textbook, notepad and pencil.png",
        "title": "ফ্রি স্টাডি বুকস",
        "subtitle": "পাঠ্যবই, সহায়ক গাইড ও রিসোর্স সমূহ",
        "buttonText": "বই পড়ুন",
      },
      {
        "image": "assets/images/Group of people at a workshop.png",
        "title": "স্টাডি গ্রুপে যোগ দিন",
        "subtitle": "সহপাঠীদের সাথে শিখুন ও আলোচনা করুন",
        "buttonText": "গ্রুপে যোগ দিন",
      },
    ];

    final String defaultImage = "assets/images/background.png";

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
                banners.map((banner) {
                  String imagePath =
                      (banner["image"] != null && banner["image"]!.isNotEmpty)
                          ? banner["image"]!
                          : defaultImage;

                  return Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(width: 1.0, color: Colors.grey),
                          image: DecorationImage(
                            image: AssetImage(imagePath),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: [
                              PRIMARY_COLOR.withAlpha(226),
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        right: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              banner["title"]!,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              banner["subtitle"]!,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: SECONDARY_BACKGROUND,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                // Navigate to relevant section
                              },
                              child: Text(banner["buttonText"]!),
                            ),
                          ],
                        ),
                      ),
                    ],
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
                        return GestureDetector(
                          onTap: () {
                            onTextClicked(category);
                          },
                          child: CategoryCard(category: category),
                        );
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
                        imagePath: "https://i.ibb.co/nq5n03vm/e552cf5654ad.jpg",
                        title: "47th BCS CRASH COURSE",
                      ),
                      CategoryItem(
                        imagePath: "https://i.ibb.co/nq5n03vm/e552cf5654ad.jpg",
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
                        imagePath: "https://i.ibb.co/nq5n03vm/e552cf5654ad.jpg",
                        title: "48th BCS",
                      ),
                      CategoryItem(
                        imagePath: "https://i.ibb.co/nq5n03vm/e552cf5654ad.jpg",
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
