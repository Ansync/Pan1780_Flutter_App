int parseByteArrToInt(List<int> bytes) {
  int total = 0;
  int bits = 8;

  for (var i = 0; i < bytes.length; i++) {
    if (i == 0) {
      total |= bytes[i];
      continue;
    }
    total |= bytes[i] << bits;
    bits += 8;
  }
  return total;
}
