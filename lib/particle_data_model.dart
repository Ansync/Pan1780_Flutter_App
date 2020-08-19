import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';
import './utils.dart';

class ParticleData {
  double data;
  int timeStamp;
  ParticleData({this.data, this.timeStamp});
}

class ParticleDataSensor extends ChangeNotifier {
  Timer timer;
  int particulateCount = 0;
  int sizeCount = 0;
  String lMass = "l";
  String mMass = "m";
  String nMass = "n";
  String countO = "o";
  String countP = "p";
  String countQ = "q";

  //Particluate matter
  bool receivedL = false;
  List<ParticleData> sensorDataPointsOne = [];
  bool receivedM = false;
  List<ParticleData> sensorDataPointsTwo = [];
  bool receivedN = false;
  List<ParticleData> sensorDataPointsThree = [];

  //Particle Counts
  bool receivedO = false;
  List<ParticleData> o0Data = [];
  List<ParticleData> o1Data = [];

  bool receivedP = false;
  List<ParticleData> p0Data = [];
  List<ParticleData> p1Data = [];

  bool receivedQ = false;
  List<ParticleData> q0Data = [];
  List<ParticleData> q1Data = [];

  void addCountData(List<int> data, int ts) {
    var letter = String.fromCharCode(data[0]);
    String dataStr = String.fromCharCodes(data.sublist(1));
    var counts = dataStr.split(',');
    var count1 = double.parse(counts[0]);
    var count2 = double.parse(counts[1]);

    if (letter == "o") {
      receivedO = true;
      o0Data.add(ParticleData(data: count1.toDouble(), timeStamp: sizeCount));
      o1Data.add(ParticleData(data: count2.toDouble(), timeStamp: sizeCount));
    }

    if (letter == "p") {
      receivedP = true;
      p0Data.add(ParticleData(data: count1.toDouble(), timeStamp: sizeCount));
      p1Data.add(ParticleData(data: count2.toDouble(), timeStamp: sizeCount));
    }

    if (letter == "q") {
      receivedQ = true;
      q0Data.add(ParticleData(data: count1.toDouble(), timeStamp: sizeCount));
      q1Data.add(ParticleData(data: count2.toDouble(), timeStamp: sizeCount));
    }

    if (receivedO && receivedP && receivedQ) {
      sizeCount++;
      receivedO = !receivedO;
      receivedP = !receivedP;
      receivedQ = !receivedQ;
    }

    if (o0Data.length > 10 ||
        o1Data.length > 10 ||
        p0Data.length > 10 ||
        p1Data.length > 10 ||
        q0Data.length > 10 ||
        q1Data.length > 10) {
      o0Data.removeAt(0);
      o1Data.removeAt(0);
      p0Data.removeAt(0);
      p1Data.removeAt(0);
      q0Data.removeAt(0);
      q1Data.removeAt(0);
    }
    secretNotify();
  }

  void addParticleData(String data, int ts) {
    var letter = data[0];
    if (letter == lMass) {
      sensorDataPointsOne.add(ParticleData(
          data: double.parse(data.substring(1)), timeStamp: particulateCount));
      receivedL = true;
    }
    if (letter == mMass) {
      sensorDataPointsTwo.add(ParticleData(
          data: double.parse(data.substring(1)), timeStamp: particulateCount));
      receivedM = true;
    }
    if (letter == nMass) {
      receivedN = true;
      sensorDataPointsThree.add(ParticleData(
          data: double.parse(data.substring(1)), timeStamp: particulateCount));
    }

    if (receivedL && receivedM && receivedN) {
      particulateCount++;
      receivedL = !receivedL;
      receivedM = !receivedM;
      receivedN = !receivedN;
    }

    //if we get too many values start dropping from the front
    if (sensorDataPointsOne.length > 10 ||
        sensorDataPointsTwo.length > 10 ||
        sensorDataPointsThree.length > 10) {
      sensorDataPointsOne.removeAt(0);
      sensorDataPointsTwo.removeAt(0);
      sensorDataPointsThree.removeAt(0);
    }

    secretNotify();
  }

  void secretNotify() {
    notifyListeners();
  }

  void start() {
    particulateCount = 0;
    sizeCount = 0;
  }

  void cleanUp() {
    sensorDataPointsOne.clear();
    sensorDataPointsTwo.clear();
    sensorDataPointsThree.clear();
    particulateCount = 0;
    sizeCount = 0;

    o0Data.clear();
    o1Data.clear();

    p0Data.clear();
    p1Data.clear();

    q0Data.clear();
    q1Data.clear();
  }
}
