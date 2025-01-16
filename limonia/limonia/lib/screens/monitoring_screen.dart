import 'dart:math';

import 'package:flutter/material.dart';
import 'package:limonia/constant/constant.dart';
import 'package:limonia/screens/home_screen.dart';
import 'package:limonia/screens/notification_screen.dart';
import 'package:limonia/screens/register_screen.dart';
import 'package:limonia/service/MqttHandler.dart';
import 'package:limonia/widgets/custom_fit_height_container.dart';
import 'package:limonia/widgets/custom_text.dart';

class MonitoringScreen extends StatefulWidget {
  const MonitoringScreen({super.key});

  @override
  State<MonitoringScreen> createState() => _MonitoringScreenState();
}

class _MonitoringScreenState extends State<MonitoringScreen> {
  MqttHandler mqttHandler = MqttHandler();

  @override
  void initState() {
    super.initState();
    mqttHandler.connect();
  }

  final List<String> _tabs = ["Amonia", "Temperature", "pH"];
  final List<Color> _activeColors = [
    Constant.colorPrimary100,
    Constant.colorPrimary100,
    Constant.colorPrimary100
  ];
  final Color _inactiveColor = Constant.grey100;
  final Color _inactiveTextColor = Constant.colorPrimary100;
  int _activeTabIndex = 0;
  double progress = 0.52;
  double tempMaxValue = 105;
  double ammoniaMaxValue = 1.5;
  double phMaxValue = 14;

  _checkProgress({progress, satuan}) {
    double progressMapped = 0;
    if (satuan == "Celcius") {
      if (progress > 35) {
        progressMapped = 1;
      } else if (progress <= 20) {
        progressMapped = 0.01;
      } else {
        progressMapped = (progress - 20) / 15;
      }
    } else if (satuan == "mg/l") {
      if (progress > 1.5) {
        progressMapped = 1;
      } else {
        progressMapped = progress / 1.5;
      }
    } else if (satuan == "pH") {
      if (progress > 10 || progress < 4) {
        progressMapped = 1;
      } else {
        progressMapped = ((progress - 7).abs()) / 3;
      }
    }
    return CustomRadialCircularProgress(
      title: satuan, // Title text
      subtitle: progress.toString(), // Subtitle text
      progress: progressMapped,
    );
    // if (progress >= 0.0 && progress <= 0.50) {
    //   return CustomCircularIndicator(
    //     title:satuan, // Title text
    //     subtitle: progress.toString(), // Subtitle text
    //     progress: progressMapped,
    //   );
    // } else if (progress > 0.50) {
    //   return CustomRadialCircularProgress(
    //     title:satuan, // Title text
    //     subtitle: progress.toString(), // Subtitle text
    //     progress: progressMapped,
    //   );
    // } else if (progress > 0.80 && progress <= 0.100) {
    //   return CustomCircularIndicator(
    //     title:satuan, // Title text
    //     subtitle: progress.toString(), // Subtitle text
    //     progress: progressMapped,
    //   );
    // }
  }

  Widget _checkTab() {
    if (_activeTabIndex == 0) {
      var _progressAmonia = 0.10;
      return Expanded(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 36.0),
          child: CustomFitHeightContainer(
            backgroundColor: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ValueListenableBuilder<double>(
                  builder: (BuildContext context, double value, Widget? child) {
                    String status = 'Aman';
                    Color statusColor = Constant.colorPrimary800;
                    if (value > 0.5) {
                      status = 'Warning';
                      statusColor = Constant.yellow1000;
                    }
                    if (value > 1) {
                      status = 'Danger';
                      statusColor = Constant.red1000;
                    }
                    return CustomText(
                      text: status,
                      fontSize: 24.0,
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.center,
                    );
                  },
                  valueListenable: mqttHandler.ammonia,
                ),
                SizedBox(
                  height: 60,
                ),
                ValueListenableBuilder<double>(
                  builder: (BuildContext context, double value, Widget? child) {
                    return _checkProgress(
                        progress: mqttHandler.ammonia.value, satuan: "mg/l");
                  },
                  valueListenable: mqttHandler.ammonia,
                ),
                SizedBox(
                  height: 8.0,
                ),
                CustomText(
                  text: 'Max: 2 mg/l',
                  fontSize: 18.0,
                  color: Constant.colorPrimary800,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 35.0,
                ),
                CustomText(
                  text: 'Amonia',
                  fontSize: 32.0,
                  color: Constant.colorPrimary800,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 8.0,
                ),
                CustomText(
                  text: 'Tanggal: 12 Sep 2024',
                  fontSize: 16.0,
                  color: Constant.colorPrimary800,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                ),
                CustomText(
                  text: 'Waktu: 08.00 WIB',
                  fontSize: 16.0,
                  color: Constant.colorPrimary800,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    } else if (_activeTabIndex == 1) {
      var _progressTemperature = 0.59;
      return Expanded(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 36.0),
          child: CustomFitHeightContainer(
            backgroundColor: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ValueListenableBuilder<double>(
                  builder: (BuildContext context, double value, Widget? child) {
                    String status = 'Aman';
                    Color statusColor = Constant.colorPrimary800;
                    if (value >= 25) {
                      status = 'Warning';
                      statusColor = Constant.yellow1000;
                    }
                    if (value > 30) {
                      status = 'Danger';
                      statusColor = Constant.red1000;
                    }
                    return CustomText(
                      text: status,
                      fontSize: 24.0,
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.center,
                    );
                  },
                  valueListenable: mqttHandler.temperature,
                ),
                SizedBox(
                  height: 60,
                ),
                ValueListenableBuilder<double>(
                  builder: (BuildContext context, double value, Widget? child) {
                    return _checkProgress(
                        progress: mqttHandler.temperature.value,
                        satuan: "Celcius");
                  },
                  valueListenable: mqttHandler.temperature,
                ),
                SizedBox(
                  height: 8.0,
                ),
                CustomText(
                  text: 'Max: 30 Celcius',
                  fontSize: 18.0,
                  color: Constant.colorPrimary800,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 35.0,
                ),
                CustomText(
                  text: 'Temperature',
                  fontSize: 32.0,
                  color: Constant.colorPrimary800,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 8.0,
                ),
                CustomText(
                  text: 'Tanggal: 12 Sep 2024',
                  fontSize: 16.0,
                  color: Constant.colorPrimary800,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                ),
                CustomText(
                  text: 'Waktu: 08.00 WIB',
                  fontSize: 16.0,
                  color: Constant.colorPrimary800,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      var _progressPh = 0.90;
      return Expanded(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 36.0),
          child: CustomFitHeightContainer(
            backgroundColor: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ValueListenableBuilder<double>(
                  builder: (BuildContext context, double value, Widget? child) {
                    String status = 'Aman';
                    Color statusColor = Constant.colorPrimary800;
                    if (value <= 6 || value >= 8) {
                      status = 'Warning';
                      statusColor = Constant.yellow1000;
                    }
                    if (value < 5 || value > 9) {
                      status = 'Danger';
                      statusColor = Constant.red1000;
                    }
                    return CustomText(
                      text: status,
                      fontSize: 24.0,
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.center,
                    );
                  },
                  valueListenable: mqttHandler.ph,
                ),
                SizedBox(
                  height: 60,
                ),
                ValueListenableBuilder<double>(
                  builder: (BuildContext context, double value, Widget? child) {
                    return _checkProgress(
                        progress: mqttHandler.ph.value, satuan: "pH");
                  },
                  valueListenable: mqttHandler.ph,
                ),
                SizedBox(
                  height: 8.0,
                ),
                CustomText(
                  text: 'Max: 14 pH',
                  fontSize: 18.0,
                  color: Constant.colorPrimary800,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 35.0,
                ),
                CustomText(
                  text: 'pH',
                  fontSize: 32.0,
                  color: Constant.colorPrimary800,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 8.0,
                ),
                CustomText(
                  text: 'Tanggal: 12 Sep 2024',
                  fontSize: 16.0,
                  color: Constant.colorPrimary800,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                ),
                CustomText(
                  text: 'Waktu: 08.00 WIB',
                  fontSize: 16.0,
                  color: Constant.colorPrimary800,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/live_monitoring_screen.png', // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 45.0,
                ),
                CustomText(
                  text: 'Live Monitoring',
                  fontSize: 24.0,
                  color: Constant.white,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 24.0,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      _tabs.length,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                          width: 200.0,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _activeTabIndex = index;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _activeTabIndex == index
                                  ? _activeColors[index] // Active color
                                  : _inactiveColor, // Inactive color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                            ),
                            child: Text(
                              _tabs[index],
                              style: TextStyle(
                                color: _activeTabIndex == index
                                    ? Colors.white
                                    : _inactiveTextColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                _checkTab()
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CustomCircularIndicator extends StatelessWidget {
  final String title;
  final String subtitle;
  final double progress;

  Color lineColor = Color(0xFF4874A6);
  Color backgroundColor = Colors.white;
  Color strokeColor = Colors.black;
  _changeColor({progress, title}) {
    if (progress <= 0.33) {
      lineColor = Color(0xFF4874A6);
      backgroundColor = Colors.white;
      strokeColor = const Color.fromRGBO(0, 0, 0, 1);
    } else if (progress > 0.33 && progress <= 0.67) {
      lineColor = Constant.yellow1000;
      backgroundColor = Constant.yellow1000;
      strokeColor = Constant.yellow1000;
    } else {
      lineColor = Constant.red1000;
      backgroundColor = Constant.red1000;
      strokeColor = Constant.red1000;
    }
  }

  CustomCircularIndicator({
    required this.title,
    required this.subtitle,
    required this.progress,
  }) {
    _changeColor(progress: progress);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            painter: CircularIndicatorPainter(progress: progress),
            size: Size(200, 200),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: subtitle,
                fontSize: 50.0,
                color: Constant.colorPrimary800,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
              ),
              CustomText(
                text: title,
                fontSize: 24.0,
                color: Constant.colorBlack1000,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4),
            ],
          ),
        ],
      ),
    );
  }
}

class CircularIndicatorPainter extends CustomPainter {
  final double progress; // Progress value (e.g., 0.75 for 75%)
  CircularIndicatorPainter({required this.progress}) {
    _changeColor(progress: progress);
  }
  Color lineColor = Color(0xFF4874A6);
  Color backgroundColor = Colors.white;
  Color strokeColor = Colors.black;
  _changeColor({progress}) {
    if (progress <= 0.33) {
      lineColor = Color(0xFF4874A6);
      backgroundColor = Colors.white;
      strokeColor = Colors.black;
    } else if (progress > 0.33 && progress <= 0.67) {
      lineColor = Constant.yellow1000;
      backgroundColor = Constant.yellow1000;
      strokeColor = Constant.yellow1000;
    } else {
      lineColor = Constant.red1000;
      backgroundColor = Constant.red1000;
      strokeColor = Constant.red1000;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    double strokeWidth = 12.0;
    double radius = size.width / 2 - strokeWidth / 2;

    Paint backgroundPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15.0;

    Paint borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(size.center(Offset.zero), radius, backgroundPaint);
    canvas.drawCircle(size.center(Offset.zero), radius, borderPaint);

    // Paint for radial lines
    Paint linePaint = Paint()
      ..color = (progress <= 80) ? Constant.white : lineColor
      ..strokeWidth = 2.0;

    double lineLength = 20.0;
    double startAngle = -pi;
    double endAngle = pi / 9;
    double angleStep = 30 / radius;

    for (double theta = startAngle; theta <= endAngle; theta += angleStep) {
      double x1 = size.width / 2 + (radius + lineLength) * cos(theta);
      double y1 = size.height / 2 + (radius + lineLength) * sin(theta);

      double x2 = size.width / 2 + (radius + 2 * lineLength) * cos(theta);
      double y2 = size.height / 2 + (radius + 2 * lineLength) * sin(theta);

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), linePaint);
    }

    Paint progressPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    double startAngleTwo = -pi / 2;
    double sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: size.center(Offset.zero), radius: radius),
      startAngleTwo,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CustomRadialCircularProgress extends StatelessWidget {
  final String title;
  final String subtitle;
  final double progress;

  Color lineColor = Color(0xFF4874A6);
  Color backgroundColor = Colors.white;
  Color strokeColor = Colors.black;
  _changeColor({progress}) {
    if (progress <= 0.33) {
      lineColor = Color(0xFF4874A6);
      backgroundColor = Colors.white;
      strokeColor = Colors.black;
    } else if (progress > 0.33 && progress <= 0.67) {
      lineColor = Constant.yellow1000;
      backgroundColor = Constant.yellow1000;
      strokeColor = Constant.yellow1000;
    } else {
      lineColor = Constant.red1000;
      backgroundColor = Constant.red1000;
      strokeColor = Constant.red1000;
    }
  }

  CustomRadialCircularProgress({
    required this.title,
    required this.subtitle,
    required this.progress,
  }) {
    _changeColor(progress: progress);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            painter: RadialCircularProgress(progress),
            size: Size(200, 200),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: subtitle,
                fontSize: 50.0,
                color: lineColor,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
              ),
              CustomText(
                text: title,
                fontSize: 24.0,
                color: Constant.colorBlack1000,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4)
            ],
          ),
        ],
      ),
    );
  }
}

class RadialCircularProgress extends CustomPainter {
  final double progress;
  RadialCircularProgress(this.progress) {
    _changeColor(progress: progress);
  }

  Color lineColor = Color(0xFF4874A6);
  Color backgroundColor = Colors.white;
  Color strokeColor = Colors.black;
  _changeColor({progress}) {
    if (progress <= 0.33) {
      lineColor = Color(0xFF4874A6);
      backgroundColor = Colors.white;
      strokeColor = Colors.black;
    } else if (progress > 0.33 && progress <= 0.67) {
      lineColor = Constant.yellow1000;
      backgroundColor = Constant.yellow1000;
      strokeColor = Constant.yellow1000;
    } else {
      lineColor = Constant.red1000;
      backgroundColor = Constant.red1000;
      strokeColor = Constant.red1000;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    double strokeWidth = 12.0;
    double radius = size.width / 2 - strokeWidth / 2;

    // Paint for background circle
    Paint backgroundPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15.0;

    // Paint for progress arc
    Paint strokePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 17.0;

    canvas.drawCircle(size.center(Offset.zero), radius, strokePaint);

    Paint progressPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw background circle
    canvas.drawCircle(size.center(Offset.zero), radius, backgroundPaint);

    Paint linePaint = Paint()
      ..color = (progress <= 0.67) ? Constant.white : lineColor
      ..strokeWidth = 2.0;

    double lineLength = 20.0;
    double endAngle = pi / 9;
    double angleStep = 30 / radius;

    // Draw progress arc
    double startAngle = -pi / 2; // Start at the top center
    double sweepAngle = 2 * pi * progress; // Progress angle based on percentage
    double startAngles = -pi;

    for (double theta = startAngles; theta <= endAngle; theta += angleStep) {
      double x1 = size.width / 2 + (radius + lineLength) * cos(theta);
      double y1 = size.height / 2 + (radius + lineLength) * sin(theta);

      double x2 = size.width / 2 + (radius + 2 * lineLength) * cos(theta);
      double y2 = size.height / 2 + (radius + 2 * lineLength) * sin(theta);

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), linePaint);
    }
    canvas.drawArc(
      Rect.fromCircle(center: size.center(Offset.zero), radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );

    // Draw "signal" lines above the circle
    Paint signalPaint = Paint()
      ..color = lineColor
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    double signalRadius = radius + 20;
    if (progress > 0.33 && progress <= 0.67) {
      _drawSignalArc(
          canvas, size.center(Offset.zero), signalRadius, 20, signalPaint);
      _drawSignalArc(
          canvas, size.center(Offset.zero), signalRadius + 20, 30, signalPaint);
    }
  }

  void _drawSignalArc(Canvas canvas, Offset center, double radius,
      double arcLength, Paint paint) {
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi /
          4, // Start angle for the arc (slightly off-center for the right arc)
      pi / 6, // Sweep angle for the arc
      false,
      paint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3 *
          pi /
          3.5, // Start angle for the arc (slightly off-center for the left arc)
      pi / 6, // Sweep angle for the arc
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
