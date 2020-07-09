import 'package:flutter/material.dart';
import 'scan_screen.dart';
import 'device_screen.dart';
import 'grideye.dart';
import 'particle_sensor.dart';
import 'package:syncfusion_flutter_core/core.dart';

void main() {
  SyncfusionLicense.registerLicense("NT8mJyc2IWhia31hfWN9Z2doYmF8YGJ8ampqanNiYmlmamlmanMDHmgxITYnEzI9ICo9MH0wPD4=");
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Panasonic Relay Control',
    initialRoute: '/',
    routes: {
      "/": (context) => ScanForDevices(),
      "/device": (context) => Device(),
      "/grideye": (context) => Grideye(),
      "/particle_sensor": (context) => ParticleSensor(),
    },
  ));
}