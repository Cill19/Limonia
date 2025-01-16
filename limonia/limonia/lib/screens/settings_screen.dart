import 'package:flutter/material.dart';
import 'package:limonia/constant/constant.dart';
import 'package:limonia/screens/account_screen.dart';
import 'package:limonia/screens/login_screen.dart';
import 'package:limonia/widgets/circular_image_with_camera.dart';
import 'package:limonia/widgets/custom_button.dart';
import 'package:limonia/widgets/custom_card_with_shadow.dart';
import 'package:limonia/widgets/custom_email_field.dart';
import 'package:limonia/widgets/custom_name_field.dart';
import 'package:limonia/widgets/custom_password_field.dart';
import 'package:limonia/widgets/custom_text.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

class SettingsScreen extends StatefulWidget {
  SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _fullname = "";
  String _email = "";
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _logout() async {
    try {
      // Menghapus data dari secure storage
      await storage.write(key: 'name', value: "");
      await storage.write(key: 'email', value: "");
      await storage.write(key: 'id', value: "");

      // Menavigasi ke halaman login setelah logout
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      // Tangkap error jika ada masalah dengan penyimpanan atau navigasi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during logout: $e')),
      );
    }
  }

  Future<void> _loadUserData() async {
    String? fullname = await storage.read(key: 'name');
    String? email = await storage.read(key: 'email');
    setState(() {
      _fullname = fullname ?? "Mahasiswa";
      _email = email ?? "Mahasiswa@gmail.com";
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
              'assets/notification_screen.png', // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          // Overlaying Content in Center
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 31.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 48,
                  ),
                  CustomText(
                    text: 'Settings',
                    fontSize: 24.0,
                    color: Constant.white,
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 45,
                  ),
                  CircularImageWithCamera(
                    imagePath:
                        'assets/avatar.png', // Replace with your image asset path
                    cameraIconPath:
                        'assets/camera.png', // Replace with your camera icon path
                    showCameraIcon:
                        false, // Toggle to false to hide the camera icon
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  CustomText(
                    text: _fullname,
                    fontSize: 14.0,
                    color: Constant.colorBlack1000,
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.center,
                  ),
                  CustomText(
                    text: _email,
                    fontSize: 12.0,
                    color: Constant.colorBlack1000,
                    fontWeight: FontWeight.normal,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  CustomCardWithShadow(
                    assetPath:
                        'assets/ic_avatar.png', // Replace with your asset path
                    title: 'Account',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AccountScreen()));
                    },
                  ),
                  Expanded(
                      child: SizedBox(
                    height: 24.0,
                  )),

                  Container(
                      width: double.infinity,
                      child: CustomButton(
                        text: "Logout", 
                        onPressed: () {
                          _logout();
                          })),

                  SizedBox(
                    height: 24.0,
                  ),

                  // Add more widgets here if needed
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
