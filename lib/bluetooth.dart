import 'package:flutter_blue/flutter_blue.dart';
import 'state.dart';
import 'dart:async';

final state = MyState();

//UUIDS
const deviceLocalName = "AnsyncPan";
const theService = "6e400001-b5a3-f393-e0a9-e50e24dcca9e";
const setterUUID = "6e400002-b5a3-f393-e0a9-e50e24dcca9e";
const notifyUUID = "6e400003-b5a3-f393-e0a9-e50e24dcca9e";
const getGrideyeDataUUID = "";
const getParticleDataUUID = "";

class Bluetooth {
  var flutterBlue = FlutterBlue.instance;
  List<BluetoothDevice> scannedDevices = List();
  List<BluetoothCharacteristic> characteristics = List();
  Map<BluetoothDevice, List<BluetoothService>> devices = Map();
  StreamSubscription<ScanResult> scanSubscription;
  BluetoothDevice selectedDevice;
  List<BluetoothService> selectedServices;
  bool devicesFound = false;

  //lmn = mass
  //pq = counts
  Future<void> scanForDevices() async {
    scannedDevices.length = 0;
    scanSubscription?.cancel();
    devicesFound = false;
    var idsFound = Set<String>();

    scanSubscription =
        flutterBlue.scan(timeout: Duration(seconds: 5)).listen((scanResult) {
      print("Found: ${scanResult.device.name}.");
      if (scanResult.device.name.startsWith("Pan")) {
        devicesFound = true;
        if (!idsFound.contains(scanResult.device.id.id)) {
          scannedDevices.add(scanResult.device);
        }
        idsFound.add(scanResult.device.id.id);
      }
    }, onDone: () {
      if (devicesFound) {
        print("Found Bluetooth Devices.");
      } else {
        print("Found No Bluetooth Devices.");
      }
    });
  }

  Future<void> triggerInitState() async {
    await state.writeChar?.write("\n".codeUnits, withoutResponse: false);
  }

  Future<void> setRelay(bool status, int relay) async {
    int x;
    if (status)
      x = 1;
    else
      x = 0;

    print(x);
    try {
      await state.writeChar
          ?.write("r$relay $x\n".codeUnits, withoutResponse: false);
    } catch (err) {
      print("Error writing characteristic: $err");
    }
  }

  Future<void> receiveStatus() async {
    state.readChar.setNotifyValue(true);
    await for (List<int> v in state.readChar.value) {
      if (v.length > 0) {
        if (v[0] >= 65 && v[0] <= 72) {
          state.maskData.fillQuarterMask(v);
          state.maskData.secretNotify();
        } else if (v[0] >= 108 && v[0] <= 112) {
          var data = String.fromCharCodes(v, 0, v.length);
          var timestamp = (DateTime.now().millisecondsSinceEpoch / 1000).ceil();
          state.particleSensor.addParticleData(data, timestamp);
        }
      }
    }
  }

  Future<void> getServices() async {
    selectedServices = await state.selectedBTDevice.discoverServices();
    selectedServices.forEach((service) async {
      print("Service Found: " + service.uuid.toString());
      if (theService != service.uuid.toString()) {
        return;
      }

      for (BluetoothCharacteristic c in service.characteristics) {
        print("Characteristic Found: " + c.uuid.toString());
        if (setterUUID == c.uuid.toString()) {
          state.writeChar = c;
        } else if (notifyUUID == c.uuid.toString()) {
          state.readChar = c;
        }
      }

      if (null != state.readChar) {
        receiveStatus(); // Don't await!
      }
    });
  }
}
