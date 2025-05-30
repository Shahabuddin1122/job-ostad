import 'package:client/models/inputType.dart';
import 'package:client/widgets/customInput.dart';
import 'package:client/widgets/showDialog.dart';
import 'package:flutter/material.dart';
import 'package:client/utils/constants.dart';

class ProfileInfo extends StatefulWidget {
  const ProfileInfo({super.key});

  @override
  _ProfileInfoState createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: "John Doe");
  final _emailController = TextEditingController(text: "john.doe@example.com");
  final _phoneController = TextEditingController(text: "+1234567890");
  final _bioController = TextEditingController(
    text: "Quiz enthusiast and trivia lover!",
  );
  final _passwordController = TextEditingController(text: "123456");

  String _selectedEducation = "Bachelor's Degree";
  bool _notificationsEnabled = true;
  bool _isLoading = false;

  final List<String> _educationLevels = [
    "High School",
    "Bachelor's Degree",
    "Master's Degree",
    "PhD",
    "Other",
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _changeProfilePicture() {
    showModalBottomSheet(
      context: context,
      backgroundColor: BACKGROUND,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Change Profile Picture',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: TEXT,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildImageOption(Icons.camera_alt, 'Camera'),
                  _buildImageOption(Icons.photo_library, 'Gallery'),
                  _buildImageOption(Icons.delete, 'Remove'),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: ACCENT,
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BACKGROUND,
      appBar: AppBar(
        backgroundColor: PRIMARY_COLOR,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: BACKGROUND),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: BACKGROUND,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: Text(
              'Save',
              style: TextStyle(
                color: BACKGROUND,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture Section
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: PRIMARY_COLOR, width: 3),
                            image: DecorationImage(
                              image: AssetImage('assets/images/user.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: ACCENT,
                              shape: BoxShape.circle,
                              border: Border.all(color: BACKGROUND, width: 2),
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                Icons.camera_alt,
                                color: BACKGROUND,
                                size: 18,
                              ),
                              onPressed: _changeProfilePicture,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Change Profile Picture',
                      style: TextStyle(
                        color: PRIMARY_COLOR,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32),

              // Name Field
              CustomInput(
                controller: _nameController,
                label: 'Full Name',
                prefixIcon: Icons.person,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),

              SizedBox(height: 20),

              // Email Field
              CustomInput(
                controller: _emailController,
                label: 'Email Address',
                prefixIcon: Icons.email,
                inputType: InputType.email,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),

              SizedBox(height: 20),

              // Phone Field
              CustomInput(
                controller: _phoneController,
                label: 'Phone Number',
                prefixIcon: Icons.phone,
                inputType: InputType.phone,
              ),

              SizedBox(height: 20),

              // Education Dropdown
              CustomInput(
                label: 'Education Level',
                prefixIcon: Icons.school,
                dropdownValue: _selectedEducation,
                dropdownItems: _educationLevels,
                onChanged: (value) {
                  setState(() {
                    _selectedEducation = value;
                  });
                },
              ),

              SizedBox(height: 20),

              CustomInput(
                label: 'Password',
                controller: _passwordController,
                inputType: InputType.password,
                prefixIcon: Icons.lock,
                hintText: 'Enter your password',
                validator: InputValidators.password,
              ),

              SizedBox(height: 20),

              // Bio Field
              CustomInput(
                label: 'Bio',
                controller: _bioController,
                inputType: InputType.multiline,
                prefixIcon: Icons.description,
                hintText: 'Tell us about yourself...',
                maxLength: 150,
                showCounter: true,
                helperText: 'Write a short bio about yourself',
              ),

              SizedBox(height: 20),

              // Notifications Toggle
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: BORDER_COLOR.withAlpha(75)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.notifications, color: PRIMARY_COLOR),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Push Notifications',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: TEXT,
                            ),
                          ),
                          Text(
                            'Receive quiz reminders and updates',
                            style: TextStyle(
                              fontSize: 12,
                              color: TEXT.withAlpha(146),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _notificationsEnabled,
                      onChanged: (value) {
                        setState(() {
                          _notificationsEnabled = value;
                        });
                      },
                      activeColor: ACCENT,
                      activeTrackColor: ACCENT.withAlpha(100),
                    ),
                  ],
                ),
              ),

              // Delete Account Button
              Center(
                child: TextButton(
                  onPressed: () => showCustomDialog(
                    context: context,
                    title: "Delete Account",
                    content:
                        "Are you sure you want to delete your account? This action cannot be undone.",
                    onConfirm: () {},
                  ),
                  child: Text(
                    'Delete Account',
                    style: TextStyle(
                      color: INCORRECT,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageOption(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: PRIMARY_COLOR.withAlpha(70),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(icon, color: PRIMARY_COLOR),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 12, color: TEXT)),
      ],
    );
  }
}
