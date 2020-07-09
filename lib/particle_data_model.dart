import 'package:flutter/material.dart';
import 'dart:async';

class ParticleData {
  double data;
  int timeStamp;
  ParticleData({this.data, this.timeStamp});
}

class ParticleDataSensor extends ChangeNotifier {
  Timer timer;
  int count = 0;
  String lMass = "l";
  String mMass = "m";
  String nMass = "n";
  String countO = "o";
  String countP = "p";
  String countQ = "q";
  bool receivedL = false;
  bool receivedM = false;
  bool receivedN = false;

  List<ParticleData> sensorDataPointsOne = [];
  List<ParticleData> sensorDataPointsTwo = [];
  List<ParticleData> sensorDataPointsThree = [];
  
  void addParticleData(String data, int ts) {
    var letter = data[0];
    //print("Data: $data");
    if (letter == lMass) {
      sensorDataPointsOne.add(ParticleData(data: double.parse(data.substring(1)), timeStamp: count));
    }
    if (letter == mMass) {
      sensorDataPointsTwo.add(ParticleData(data: double.parse(data.substring(1)), timeStamp: count));
    }
    if (letter == nMass) {
      sensorDataPointsThree.add(ParticleData(data: double.parse(data.substring(1)), timeStamp: count));
      count++;
    }

    //Todo - Add our counts?
    // if(letter == countO) {

    // }
    // if (letter == countP) {

    // }
    // if (letter == countP) {

    // }


    //if we get too many values start dropping from the front
    if(sensorDataPointsOne.length > 6) {
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
    timer?.cancel();
    count = 0;
  }

  void cleanUp() {
    sensorDataPointsOne.clear();
    sensorDataPointsTwo.clear();
    sensorDataPointsThree.clear();
    timer?.cancel();
    count = 0;
  }
}