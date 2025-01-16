import 'package:flutter/material.dart';
import 'package:limonia/constant/constant.dart';
import 'package:limonia/screens/account_screen.dart';
import 'package:limonia/screens/home_screen.dart';
import 'package:limonia/screens/monitoring_screen.dart';
import 'package:limonia/screens/notification_screen.dart';
import 'package:limonia/screens/register_screen.dart';
import 'package:limonia/screens/settings_screen.dart';
import 'package:limonia/widgets/custom_text.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LiveMonitoringScreen extends StatefulWidget {
  const LiveMonitoringScreen({super.key});

  @override
  State<LiveMonitoringScreen> createState() => _LiveMonitoringScreenState();
}

class _LiveMonitoringScreenState extends State<LiveMonitoringScreen> {
  @override
  void initState() {
    super.initState();
  }

  int _currentIndex = 0;

  final List<BottomNavItem> _navItems = [
    BottomNavItem(
      activeIcon: 'assets/home_active.png',
      inactiveIcon: 'assets/home_nonactive.png',
      label: 'Home',
    ),
    BottomNavItem(
      activeIcon: 'assets/notif_active.png',
      inactiveIcon: 'assets/notif_nonactive.png',
      label: 'Notification',
    ),
    BottomNavItem(
      activeIcon: 'assets/settings_active.png',
      inactiveIcon: 'assets/settings_nonactive.png',
      label: 'Profile',
    ),
  ];

  final List<Widget> _pages = [
    MonitoringScreen(),
    NotificationScreen(),
    SettingsScreen(),
    AccountScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fullscreen Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/live_monitoring_screen.png', // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          // Overlaying Content in Center
          _pages[_currentIndex]
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Constant.colorPrimary600,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: _navItems.map((item) {
          return BottomNavigationBarItem(
            icon: Image.asset(
              _currentIndex == _navItems.indexOf(item)
                  ? item.activeIcon
                  : item.inactiveIcon,
              width: 24,
              height: 24,
            ),
            label: item.label,
          );
        }).toList(),
      ),
    );
  }
}

class BottomNavItem {
  final String activeIcon;
  final String inactiveIcon;
  final String label;

  BottomNavItem({
    required this.activeIcon,
    required this.inactiveIcon,
    required this.label,
  });
}
