import 'package:flutter/material.dart';
import 'package:job_ostad/utils/custom_theme.dart';

class Overview extends StatelessWidget {
  const Overview({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: Theme.of(context).defaultPadding,
        child: Column(children: [Text("Overview page")]),
      ),
    );
  }
}
