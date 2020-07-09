import 'dart:core';
import 'package:flutter/material.dart';

class MaskData extends ChangeNotifier{
  MaskData();
  
  var mask = List<dynamic>.filled(64, 1);
  
  int getPixel(dynamic r, dynamic c) {
    return mask[8 * r + c];
  }

  void setPixel(dynamic r, dynamic c, dynamic val) {
    mask[8 * r + c] = val;
  }

  void toggle(dynamic r, dynamic c) {
      //TODO FIX THIS TOGGLE TO = setPixel(r, c, 2 ^ getPixel(r, c));
      //setPixel(r, c, 2 ^ getPixel(r, c));
  }

  List<dynamic> getMask() => mask;

  void fillMaskData(List<dynamic> cloudMask) {
    mask = new List<dynamic>.from(cloudMask);
    notifyListeners();
  }

  void fillQuarterMask(List<int> chunk) {
    var row = chunk[0] - 65;
    var rowData = String.fromCharCodes(chunk, 2);
    var col = 0;
    for(var pixelData = 0; pixelData < rowData.length; pixelData += 2) {
      var pixelTemp = int.parse(rowData.substring(pixelData, pixelData+2), radix: 16);
      //print("pixel temp: $pixelTemp");
      setPixel(row, col, pixelTemp);
      col++;
    }
    
    // for (var bit = 1; bit < chunkLen; bit++) {
    //   row = (2 * (chunk[0] - 97)) + ((bit - 1) >> 3);
    //   col = (bit - 1) & 7;
    //   var newVal = int.parse(String.fromCharCode(chunk[bit]));
    //   setPixel(row, col, newVal);
    // }
  }

  void secretNotify() {
    notifyListeners();
  }
}
