import 'bluetooth.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'mask_data_model.dart';
import 'particle_data_model.dart';

class MyState {
  static final MyState _singleton = MyState._internal();
  factory MyState() => _singleton;
  MyState._internal();
  double deviceHeight;
  double deviceWidth;
  MaskData maskData = MaskData();
  final Bluetooth bt = Bluetooth();
  bool btConnected = false;
  bool scanning = false;
  bool connecting = false;
  BluetoothDevice selectedBTDevice;
  BluetoothCharacteristic readChar, writeChar;
  Stream<List<int>> notifyStream;
  List<bool> relayStatus = [false, false, false];
  ParticleDataSensor particleSensor = ParticleDataSensor();
}
