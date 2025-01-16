import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:limonia/service/notification.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class MqttHandler with ChangeNotifier {
  final ValueNotifier<double> temperature = ValueNotifier<double>(25);
  final ValueNotifier<double> ammonia = ValueNotifier<double>(0.12);
  final ValueNotifier<double> ph = ValueNotifier<double>(6.5);
  late MqttServerClient client;

  DateTime? lastTemperatureNotification;
  DateTime? lastAmmoniaNotification;
  DateTime? lastPHNotification;

  Future<void> initializeService() async {
    final service = FlutterBackgroundService();
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: true,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
      ),
    );
    service.startService();
  }

  Future<Object> connect() async {
    client = MqttServerClient.withPort(
        'broker.emqx.io', '02eea60409cc4e449d93c4ce6e1826ed', 1883);
    client.logging(on: true);
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.onUnsubscribed = onUnsubscribed;
    client.onSubscribed = onSubscribed;
    client.onSubscribeFail = onSubscribeFail;
    client.pongCallback = pong;
    client.keepAlivePeriod = 60;
    client.logging(on: true);

    client.setProtocolV311();

    final connMessage = MqttConnectMessage()
        .withWillTopic('willtopic')
        .withWillMessage('Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce)
        .withClientIdentifier('02eea60409cc4e449d93c4ce6e1826ed');

    print('MQTT_LOGS::Mosquitto client connecting....');

    client.connectionMessage = connMessage;
    try {
      await client.connect();
    } catch (e) {
      print('Exception: $e');
      client.disconnect();
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('MQTT_LOGS::Mosquitto client connected');
    } else {
      print('MQTT_LOGS::ERROR Mosquitto client connection failed');
      client.disconnect();
      return -1;
    }

    const tempSensorTopic = "/sensor/NTC/tempInC";
    const ammoniaSesnorTopic = "/sensor/MQ135/ammonia";
    const phSensorTopic = "/sensor/PH/phValue";
    const fgmTopic = "limonia/fgm";

    client.subscribe(tempSensorTopic, MqttQos.atMostOnce);
    client.subscribe(ammoniaSesnorTopic, MqttQos.atMostOnce);
    client.subscribe(phSensorTopic, MqttQos.atMostOnce);
    client.subscribe(fgmTopic, MqttQos.atMostOnce);

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      try {
        final now = DateTime.now();

        // Suhu
        if (c[0].topic == tempSensorTopic) {
          temperature.value = double.parse(pt);
          if (temperature.value >= 30.00) {
            if (lastTemperatureNotification == null ||
                now.difference(lastTemperatureNotification!).inMinutes >= 1) {
              _showNotification(
                'Peringatan',
                'Suhu terbaru adalah ${temperature.value.toStringAsFixed(2)}°C',
              );
              lastTemperatureNotification = now;
            }
          }
        } 
        
        // Amonia
        else if (c[0].topic == ammoniaSesnorTopic) {
          ammonia.value = double.parse(pt);
          if (ammonia.value >= 2.0) {
            if (lastAmmoniaNotification == null ||
                now.difference(lastAmmoniaNotification!).inMinutes >= 1) {
              _showNotification(
                'Peringatan',
                'Kadar amonia: ${ammonia.value.toStringAsFixed(2)} ppm',
              );
              lastAmmoniaNotification = now;
            }
          }
        } 
        
        // pH
        else if (c[0].topic == phSensorTopic) {
          ph.value = double.parse(pt);
          if (ph.value >= 14.00) {
            if (lastPHNotification == null ||
                now.difference(lastPHNotification!).inMinutes >= 1) {
              _showNotification(
                'Peringatan',
                'pH terbaru adalah ${ph.value.toStringAsFixed(2)}',
              );
              lastPHNotification = now;
            }
          }
        }
      } catch (e) {
        print('Error parsing data from topic ${c[0].topic}: $e');
      }

      notifyListeners();
    });

    return client;
  }

  void _showNotification(String title, String body) {
    Notificationservice.showInstanNotification(title, body);
  }

  // Fungsi statis yang digunakan oleh FlutterBackgroundService untuk memulai service
  static void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  // Memulai notifikasi untuk foreground service
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'background_service', 
    'Background Service', 
    importance: Importance.high,
    priority: Priority.high,
    icon: '@drawable/launch_background',
  );
  const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);
  await flutterLocalNotificationsPlugin.show(
    0, 
    'Service is running', 
    'Your background service is active', 
    platformDetails,
  );

  // Menetapkan foreground mode

  // Membuat instance MqttHandler
  final mqttHandler = MqttHandler();
  await mqttHandler.connect(); // Menghubungkan MQTT

  Timer.periodic(Duration(seconds: 10), (timer) {
    if (mqttHandler.client.connectionStatus?.state == MqttConnectionState.connected) {
      print('Service is running in background, sending data...');
      mqttHandler.client.publishMessage(
        'test/sample', 
        MqttQos.atMostOnce, 
        MqttClientPayloadBuilder().addString('Service is active').payload!,
      );
    }
  });
}


  static void onConnected() {
    print('MQTT_LOGS:: Connected');
  }

  static void onDisconnected() {
    print('MQTT_LOGS:: Disconnected');
  }

  static void onSubscribed(String topic) {
    print('MQTT_LOGS:: Subscribed topic: $topic');
  }

  static void onSubscribeFail(String topic) {
    print('MQTT_LOGS:: Failed to subscribe $topic');
  }

  static void onUnsubscribed(String? topic) {
    print('MQTT_LOGS:: Unsubscribed topic: $topic');
  }

  static void pong() {
    // print('MQTT_LOGS:: Ping response client callback invoked');
  }

  static void publishMessage(String message) {
    const pubTopic = 'test/sample';
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);

    final mqttHandler = MqttHandler(); // Harus menggunakan instance yang ada
    if (mqttHandler.client.connectionStatus?.state == MqttConnectionState.connected) {
      mqttHandler.client.publishMessage(pubTopic, MqttQos.atMostOnce, builder.payload!);
    }
  }
}
