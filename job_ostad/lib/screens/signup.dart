import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:job_ostad/utils/api_settings.dart';
import 'package:job_ostad/utils/constants.dart';
import 'package:job_ostad/utils/snackbar.dart';
import 'package:job_ostad/widgets/otpScreen.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passworcController = TextEditingController();
  String? selectEducation;

  void sendOtp(BuildContext context) async {
    ApiSettings apiSettings = ApiSettings(endPoint: 'auth/register');
    try {
      var data = {"phone_number": mobileController.text};
      final response = await apiSettings.postMethod(jsonEncode(data));
      final a = jsonDecode(response.body);
      final body = {
        "username": userController.text,
        "email": emailController.text,
        "phone_number": mobileController.text,
        "education": selectEducation,
        "password": passworcController.text,
      };
      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OtpScreen(data: body)),
        );
      }
    } catch (e) {
      SnackbarUtils.showErrorSnackbar(context, "Registration Failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              SvgPicture.asset(
                'assets/images/svg/graduation hats.svg',
                height: 200,
                fit: BoxFit.none,
              ),
              const SizedBox(height: 24),
              const Text(
                "Create a new",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const Text(
                "account",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),

              TextField(
                controller: userController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'User name',
                  hintText: 'Enter your name',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: mobileController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  hintText: 'Enter your mobile number',
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: DropdownButton<String>(
                  hint: const Text(
                    'Select Education',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 12),
                  isExpanded: true,
                  value: selectEducation,
                  items:
                      ['SSC', 'HSC', 'Undergraduate', 'Graduate'].map((
                        String item,
                      ) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectEducation = newValue!;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passworcController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.visibility_off),
                    onPressed: () {}, // Add toggle logic later if needed
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    sendOtp(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Sign Up", style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text("OR"),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/sign-in');
                    },
                    child: const Text(
                      'Sign in',
                      style: TextStyle(color: PRIMARY_COLOR),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
