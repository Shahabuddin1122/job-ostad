import 'package:flutter/material.dart';
import 'package:client/utils/custom_theme.dart';

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Peofile Info")),
      body: SingleChildScrollView(
        child: Padding(
          padding: Theme.of(context).defaultPadding,
          child: Text("data"),
        ),
      ),
    );
  }
}
