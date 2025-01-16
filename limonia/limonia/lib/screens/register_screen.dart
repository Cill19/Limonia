import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:limonia/constant/constant.dart';
import 'package:limonia/screens/live_monitoring_screen.dart';
import 'package:limonia/screens/login_screen.dart';
import 'package:limonia/widgets/custom_button.dart';
import 'package:limonia/widgets/custom_email_field.dart';
import 'package:limonia/widgets/custom_name_field.dart';
import 'package:limonia/widgets/custom_password_field.dart';
import 'package:limonia/widgets/custom_text.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:limonia/screens/login_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
final storage = FlutterSecureStorage();


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _urlngrok = "";
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _register() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All fields are required')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    final url = Uri.parse('${_urlngrok}/register'); // Replace with your API endpoint
    final body = jsonEncode({
      'name': name,
      'email': email,
      'password': password,
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 201) {
        // Registration successful
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration successful')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        // Handle errors from API
        final error = jsonDecode(response.body)['error'] ?? 'Unknown error';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: $error')),
        );
      }
    } catch (e) {
      // Handle network errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  Future<void> _loadUserData() async {
    String? baseurl = await storage.read(key: 'url');
    setState(() {
      _urlngrok = baseurl ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fullscreen Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/login_screen.png', // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          // Overlaying Content in Center
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 31.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(
                      text: 'LIMONIA',
                      fontSize: 48.0,
                      color: Constant.colorPrimary100,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 85,
                    ),
                    CustomNameField(
                      hintText: 'Name',
                      controller: _nameController,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomEmailField(
                      hintText: 'Enter your email',
                      controller: _emailController,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomPasswordField(
                      hintText: "Password",
                      controller: _passwordController,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomPasswordField(
                      hintText: "Confirm Password",
                      controller: _confirmPasswordController,
                    ),
                    const SizedBox(
                      height: 29,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ));
                      },
                      child: CustomText(
                        text: 'Are you already a member? Login now',
                        fontSize: 14.0,
                        color: Constant.colorPrimary100,
                        fontWeight: FontWeight.w400,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      width: double.infinity,
                      child: CustomButton(
                        text: "Register",
                        onPressed: _register,
                      ),
                    )
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
