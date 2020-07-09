import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'mask_data_model.dart';
import 'state.dart';

var state = MyState();

class Pixel extends StatefulWidget {
  final int row, column;
  Pixel(this.row, this.column);

  @override
  PixelState createState() => PixelState();
}

class PixelState extends State<Pixel> {
  double scaleTemperatureDown(int temp) {
    var dTemp = temp.toDouble();
    int tempMax = 100;
    int tempMin = 32;
    return ((dTemp - tempMin) / (tempMax - tempMin)) * (1.0 - (-1.0)) + -1.0;
  }

  double interpolate( double val, double y0, double x0, double y1, double x1 ) {
    return (val-x0)*(y1-y0)/(x1-x0) + y0;
  }

  double base( double val ) {
    if ( val <= -0.75 ) return 0;
    else if ( val <= -0.25 ) return interpolate( val, 0.0, -0.75, 1.0, -0.25 );
    else if ( val <= 0.25 ) return 1.0;
    else if ( val <= 0.75 ) return interpolate( val, 1.0, 0.25, 0.0, 0.75 );
    else return 0.0;
  }

  double red( double gray ) {
      return base( gray - 0.5 );
  }
  double green( double gray ) {
      return base( gray );
  }
  double blue( double gray ) {
      return base( gray + 0.5 );
  }

  Color buildPixelColor(int bit) {
    double scaledTemp = scaleTemperatureDown(bit);

    var redVal = red(scaledTemp);
    redVal = double.parse(redVal.toStringAsFixed(2));

    var greenVal = green(scaledTemp);
    greenVal = double.parse(greenVal.toStringAsFixed(2));

    var blueVal = blue(scaledTemp);
    blueVal = double.parse(blueVal.toStringAsFixed(2));

    int r = (redVal * 255).floor();
    int g = (greenVal * 255).floor();
    int b = (blueVal * 255).floor();

    //print("Red: $r\tGreen: $g\tBlue: $b");

    return Color.fromRGBO(r, g, b, 1.0);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: state.maskData,
          child: Container(
        color:
            buildPixelColor(state.maskData.mask[8 * widget.row + widget.column]),
        child: Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.black54)),
          child: SizedBox(
            width: state.deviceWidth * 0.075,
            height: state.deviceWidth * 0.075,
            child: InkWell(onTap: () async {

              var index = 8 * widget.row + widget.column;

              var newBit = state.maskData
                  .getPixel(widget.row, widget.column);

              newBit = 1 ^ newBit;

              setState(() {
                  state.maskData.toggle(widget.row, widget.column);
                });

              // var resp = await state.selectedDevice
              //     .sendCommand("updateMask:$newBit:$index");

              // if (resp) {
              //   setState(() {
              //     state.selectedDevice.maskData
              //         .toggle(widget.row, widget.column);
              //   });
              // } else {
              //   print(
              //       "${state.selectedDevice.valueMap["deviceID"]}: Failed to update mask.");
              //}
            }),
          ),
        ),
      ),
    );
  }
}

class Grideye extends StatefulWidget {
  @override
  _GrideyeState createState() => _GrideyeState();
}

class _GrideyeState extends State<Grideye> {
  Timer updateTimer;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    updateTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    double gridHeight = state.deviceHeight * 0.5;
    double sensorSliderHeight = state.deviceHeight * 0.15;

    //Build Rows / Cols for Grid
    var rows = <Widget>[];
    for (int row = 0; row < 8; row += 1) {
      var cols = <Widget>[];
      for (int col = 0; col < 8; col += 1) {
        cols.add(Pixel(row, col));
      }
      rows.add(
          Row(mainAxisAlignment: MainAxisAlignment.center, children: cols));
    }

    return Scaffold(
        appBar: AppBar(
    title: Text("Grideye", style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: state.deviceHeight * 0.03)),
    centerTitle: true,
        ),
        body: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Text("Panasonic\nAMG8833 Grideye Sensor", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: state.deviceHeight * 0.035)),
         Container(
            height: state.deviceHeight * 0.05,
          ),
      Column(mainAxisAlignment: MainAxisAlignment.center, children: rows)
    ],
        ),
      );
  }
}
