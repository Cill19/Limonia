import 'package:flutter/material.dart';
import 'package:limonia/screens/home_screen.dart';
import 'package:limonia/screens/validasi.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _urlngrok = "";
  @override
  void initState() {
    super.initState();
    _loadUserData();
    Future.delayed(Duration(seconds: 3), () async {
      await _checkApiAndNavigate();
    });
  }

  Future<void> _checkApiAndNavigate() async {
    final url = Uri.parse('${_urlngrok}/notifications');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ValidasiPage(),
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ValidasiPage(),
        ),
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
          Positioned.fill(
            child: Image.asset(
              'assets/splash_screen.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Limonia',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
