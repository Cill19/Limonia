import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:limonia/constant/constant.dart';
import 'package:limonia/screens/home_screen.dart';
import 'package:limonia/widgets/custom_button.dart';
import 'package:limonia/widgets/custom_card.dart';
import 'package:limonia/widgets/custom_password_field.dart';
import 'package:limonia/widgets/custom_text.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:limonia/service/notification.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
final storage = FlutterSecureStorage();

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class WarninMessage {
  String title = '';
  String message = '';
  bool isRead = false;
  String timestamp = '';

  WarninMessage(this.title, this.message, this.isRead, this.timestamp);
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  String _urlngrok = "";
  void initState() {
    super.initState();
    _loadUserData();
    Future.delayed(Duration(seconds: 1), () {
    fetchData();
  });
    // connectToMqtt();
  }

  List<WarninMessage> items = [];

  Future<void> fetchData() async {
    final response = await http.get(
        Uri.parse('${_urlngrok}/notifications'));
        // Notificationservice.showInstanNotification('Peringantan', 'testing');
        // Uri.parse('https://6777-36-73-32-188.ngrok-free.app/notifications'));
    if (response.statusCode == 200) {
      setState(() {
        var responseList = json.decode(response.body);
        items = [];
        for (var respItem in responseList) {
          items.add(WarninMessage(
              'Warning', respItem["message"], false, respItem["timestamp"]));
        }
        // items = json.decode(response.body);
        // items = json.decode(response.body)['title'];
      });
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
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              'assets/notification_screen.png', // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          // Overlaying Content in Center

          SafeArea(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 16.0),
                    CustomText(
                      text: 'Notification',
                      fontSize: 24.0,
                      color: Constant.white,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.center,
                    ),
                    // Notification List
                    SizedBox(
                      height: 75,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return CustomCard(
                          title: item.title,
                          subtitle: item.message,
                          isRead: item.isRead,
                          timestamp: item.timestamp,
                        );
                      },
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
