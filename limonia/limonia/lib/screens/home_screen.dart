import 'package:flutter/material.dart';
import 'package:limonia/screens/home_screen.dart';
import 'package:limonia/screens/login_screen.dart';
import 'package:limonia/service/notification.dart';
import 'package:limonia/widgets/custom_button.dart';
import 'package:limonia/widgets/custom_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fullscreen Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/onboarding_screen.png', // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          // Overlaying Content in Center
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 31.5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/onboarding_logo.png', // Replace with your image path
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  CustomText(
                    text: 'Selamat Datang di Aplikasi Monitoring Kolam Ikan',
                    fontSize: 24.0,
                    color: Color(0xFF4874A6),
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 15.0,
                  ),

                  CustomText(
                    text:
                        'Pantau kondisi kolam ikan Anda dengan mudah dan real-time',
                    fontSize: 16.0,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  Container(
                      width: double.infinity,
                      child: CustomButton(
                          text: "Next",
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ));
                          })),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
