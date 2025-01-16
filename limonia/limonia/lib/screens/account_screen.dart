import 'package:flutter/material.dart';
import 'package:limonia/constant/constant.dart';
import 'package:limonia/screens/settings_screen.dart';
import 'package:limonia/widgets/circular_image_with_camera.dart';
import 'package:limonia/widgets/custom_button.dart';
import 'package:limonia/widgets/custom_email_field.dart';
import 'package:limonia/widgets/custom_name_field.dart';
import 'package:limonia/widgets/custom_password_field.dart';
import 'package:limonia/widgets/custom_text.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final storage = FlutterSecureStorage();

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String _iduser = "";
  String _urlngrok = "";
  Future<void> _saveAccount() async {
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;
    if (password != confirmPassword) {
      // Show error if passwords do not match
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    var url = Uri.parse('${_urlngrok}/update'); // Replace with your actual API URL

    var body = jsonEncode({
      'name': name,
      'email': email,
      'password': password,
      'id': _iduser
    });

    print(body);

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Berhasil Update Data')),
          );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SettingsScreen()),
        );
      } else {
        // Handle other errors (e.g., 500 or other HTTP errors)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to register: ${response.body}')),
        );
      }
    } catch (e) {
      // Handle connection error or any other exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    String? fullname = await storage.read(key: 'name');
    String? email = await storage.read(key: 'email');
    String? id = await storage.read(key: 'id');
    String? baseurl = await storage.read(key: 'url');
    setState(() {
      _nameController.text = fullname ?? "Mahasiswa";
      _emailController.text = email ?? "Mahasiswa@gmail.com";
      _iduser = id ?? "";
      _urlngrok = baseurl ?? "";
    });
  }

  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/notification_screen.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 31.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(
                      text: 'Account',
                      fontSize: 24.0,
                      color: Constant.white,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24.0),
                    CircularImageWithCamera(
                      imagePath: 'assets/avatar.png',
                      cameraIconPath: 'assets/camera.png',
                      showCameraIcon: true,
                    ),
                    CustomNameField(
                      controller: _nameController,
                      hintText: 'Name',
                    ),
                    const SizedBox(height: 12),
                    CustomEmailField(
                      controller: _emailController,
                      hintText: 'Enter your email',
                    ),
                    const SizedBox(height: 12),
                    CustomPasswordField(
                      controller: _passwordController,
                      hintText: "Password",
                    ),
                    const SizedBox(height: 12),
                    CustomPasswordField(
                      controller: _confirmPasswordController,
                      hintText: "Confirm Password",
                    ),
                    const SizedBox(height: 29),
                    Container(
                      width: double.infinity,
                      child: CustomButton(
                        text: "Save",
                        onPressed: _saveAccount,
                      ),
                    ),
                    const SizedBox(height: 200),
                    SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
