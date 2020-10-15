import 'dart:core';
import 'package:flutter/material.dart';

class MaskData extends ChangeNotifier {
  MaskData();

  var mask = List<dynamic>.filled(64, 1);

  int getPixel(dynamic r, dynamic c) {
    return mask[8 * r + c];
  }

  void setPixel(dynamic r, dynamic c, dynamic val) {
    mask[8 * r + c] = val;
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
    for (var pixelData = 0; pixelData < rowData.length; pixelData += 2) {
      var pixelTemp =
          int.parse(rowData.substring(pixelData, pixelData + 2), radix: 16);
      setPixel(row, col, pixelTemp);
      col++;
    }
  }

  void secretNotify() {
    notifyListeners();
  }
}
