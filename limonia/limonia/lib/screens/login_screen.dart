import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:limonia/constant/constant.dart';
import 'package:limonia/screens/live_monitoring_screen.dart';
import 'package:limonia/screens/register_screen.dart';
import 'package:limonia/widgets/custom_button.dart';
import 'package:limonia/widgets/custom_email_field.dart';
import 'package:limonia/widgets/custom_password_field.dart';
import 'package:limonia/widgets/custom_text.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
final storage = FlutterSecureStorage();

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String _urlngrok = "";
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }
  Future<void> _login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email and password cannot be empty')),
      );
      return;
    }
    var url = Uri.parse('${_urlngrok}/login');

    // Data yang dikirim ke API
    var body = jsonEncode({
      'email': emailController.text,
      'password': passwordController.text,
    });
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        await storage.write(key: 'name', value: data['name']);
        await storage.write(key: 'email', value: data['email']);
        await storage.write(key: 'id', value: data['id'].toString());
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LiveMonitoringScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
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
                    CustomEmailField(
                      hintText: 'Enter your email',
                      controller: emailController,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomPasswordField(
                      hintText: "Password",
                      controller: passwordController,
                    ),
                    const SizedBox(
                      height: 29,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterScreen(),
                            ));
                      },
                      child: CustomText(
                        text: 'Not a member? Register now',
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
                        text: "Login",
                        onPressed:
                            _login, // Panggil fungsi login saat tombol ditekan
                      ),
                    ),
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
