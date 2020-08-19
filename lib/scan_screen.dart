import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:async';
import 'state.dart';

final state = MyState();

class ScanForDevices extends StatefulWidget {
  @override
  _ScanForDevicesState createState() => _ScanForDevicesState();
}

class _ScanForDevicesState extends State<ScanForDevices> {
  bool connecting = false;
  int scanTimeLeft = 10;
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    state.selectedBTDevice?.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    state.deviceHeight = MediaQuery.of(context).size.height;
    state.deviceWidth = MediaQuery.of(context).size.width;
    double bannerHeight = MediaQuery.of(context).size.height * 0.25;
    double buttonSectionHeight = MediaQuery.of(context).size.height * 0.1;
    double spaceBetween = state.deviceHeight * 0.5;
    double itemPadding = state.deviceWidth * 0.05;
    var scanningButton = RaisedButton(
      child: Text("Scanning..."),
      onPressed: null,
    );

    var scanButton = RaisedButton(
      child: Text("Scan", style: TextStyle(fontSize: 18)),
      onPressed: () async {
        setState(() {
          state.scanning = true;
        });

        await state.bt.scanForDevices();

        Timer(Duration(seconds: 5), () {
          setState(() {
            state.scanning = false;
          });
        });
        Timer.periodic(Duration(milliseconds: 100), (t) {
          if (t.tick > 100) {
            t.cancel();
          }
          setState(() {});
        });
      },
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(left: itemPadding, right: itemPadding),
        child: Column(
          children: <Widget>[
            Container(
              height: state.deviceHeight * 0.05,
            ),
            SafeArea(
              bottom: true,
              top: true,
              right: true,
              left: true,
              child: Container(
                child: SizedBox(
                  height: bannerHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Image.asset('assets/panlogo.png'),
                      Container(
                        height: state.deviceHeight * 0.05,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Image.asset('assets/futurelogo.png',
                                  height: state.deviceHeight * 0.06),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.topCenter,
              child: SizedBox(
                  height: spaceBetween,
                  child: Scrollbar(
                    child: ListView.builder(
                      itemCount: state.bt.scannedDevices.length,
                      itemBuilder: (context, index) {
                        return scannedDeviceRow(
                            index, state.bt.scannedDevices[index]);
                      },
                    ),
                  )),
            ),
            Container(
              child: SizedBox(
                height: buttonSectionHeight * 1.1,
                child: Column(
                  children: <Widget>[
                    (!connecting)
                        ? Text("")
                        : Text("Trying to connect...",
                            style: TextStyle(fontSize: 15)),
                    (!state.scanning && !connecting)
                        ? scanButton
                        : (!state.scanning && connecting)
                            ? CircularProgressIndicator()
                            : scanningButton,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _editLocation(
      BuildContext context, String key, BluetoothDevice device) async {
    state.selectedBTDevice = device;
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Center(
                child: Text(
              "${device.name}",
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  RaisedButton(
                      child: Text("Connect"),
                      onPressed: () async {
                        setState(() {
                          state.btConnected = false;
                          connecting = true;
                          print("Trying to connect.");
                        });

                        Timer(Duration(seconds: 10), () {
                          if (!state.btConnected) {
                            setState(() {
                              connecting = false;
                            });
                            Navigator.pop(context);
                          }
                        });

                        try {
                          await state.selectedBTDevice?.disconnect();
                          await state.selectedBTDevice
                              .connect(autoConnect: false);
                          await state.bt.getServices();
                          setState(() {
                            state.btConnected = true;
                            connecting = false;
                          });
                          state.particleSensor.start();
                          Navigator.popAndPushNamed(context, "/device");
                        } catch (err) {
                          setState(() {
                            connecting = false;
                            state.btConnected = false;
                          });
                          print("Error Connecting: " + err.toString());
                        }
                      }),
                ],
              ),
            ),
          );
        });
  }

  Widget scannedDeviceRow(int index, BluetoothDevice device) {
    return GestureDetector(
      onTap: (state.scanning)
          ? null
          : () {
              print("Selected Device: ${device.name}");
              _editLocation(context, index.toString(), device);
            },
      child: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 2)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text("Device Name",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(device.name)
                ],
              ),
              SizedBox(
                width: 8.0,
              ),
              Column(
                children: <Widget>[
                  Text(
                    "Device ID",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  (Platform.isIOS)
                      ? Text(device.id.id.substring(14, device.id.id.length))
                      : Text(device.id.toString())
                ],
              )
            ],
          ),
          Padding(padding: EdgeInsets.only(bottom: 2)),
          Divider()
        ],
      ),
    );
  }
}
