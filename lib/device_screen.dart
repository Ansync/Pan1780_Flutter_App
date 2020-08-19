import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'state.dart';

final state = MyState();

class Device extends StatefulWidget {
  @override
  _DeviceState createState() => _DeviceState();
}

class _DeviceState extends State<Device> {
  void getRelayStatus() async {
    await state.bt.triggerInitState();
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    Future.delayed(Duration(milliseconds: 100), () {
      state.bt.triggerInitState().then((void _) {
        setState(() {});
        print("Done.");
      }).catchError((err) {
        setState(() {});
        print("Error with triggerInitState(): $err");
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    state.particleSensor.cleanUp();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    double bannerHeight = MediaQuery.of(context).size.height * 0.3;
    double itemPadding = deviceWidth * 0.05;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.only(left: itemPadding, right: itemPadding),
          child: Column(
            children: <Widget>[
              SafeArea(
                bottom: true,
                top: true,
                right: true,
                left: true,
                child: Container(
                  child: SizedBox(
                    height: bannerHeight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: state.deviceHeight * 0.05,
                        ),
                        SafeArea(
                            bottom: true,
                            top: true,
                            right: true,
                            left: true,
                            child: Image.asset('assets/panlogo.png')),
                        Container(
                          height: state.deviceHeight * 0.05,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Image.asset('assets/futurelogo.png',
                                    height: deviceHeight * 0.06),
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
                child: SizedBox(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                        "Powered by the PAN1780 Bluetooth® 5.0 Low-Energy RF Module",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: state.deviceHeight * 0.035)),
                    Container(height: state.deviceHeight * 0.05, width: 0),
                    Text("Connected To: ${state.selectedBTDevice.name}"),
                    Container(height: state.deviceHeight * 0.05, width: 0),
                  ],
                )),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: SizedBox(
                          child: RaisedButton(
                        child: Text("Thermal Sensor Grid-Eye"),
                        onPressed: () {
                          Navigator.pushNamed(context, '/grideye');
                        },
                      )),
                    ),
                    Container(
                      child: SizedBox(
                          child: RaisedButton(
                        child: Text("Particle Sensor"),
                        onPressed: () {
                          Navigator.pushNamed(context, '/particle_sensor');
                        },
                      )),
                    ),
                  ],
                ),
              ),
              Container(
                child: SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                          child: Text("Disconnect"),
                          onPressed: () async {
                            try {
                              await state.selectedBTDevice.disconnect();
                              state.particleSensor.cleanUp();
                              Navigator.popAndPushNamed(context, "/");
                            } catch (err) {
                              print("Error Disconnecting: " + err);
                            }
                          })
                    ],
                  ),
                ),
              ),
              Container(height: state.deviceHeight * 0.05, width: 0),
            ],
          ),
        ),
      ),
    );
  }
}
