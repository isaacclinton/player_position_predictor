import 'dart:io';

import 'package:predictor/src/csv.dart';

import 'knn.dart' as knn;

Future<String> predict(Map<String, dynamic> item) async {
  // final byteStream = File(csvPath).openRead();
  // final data = parseCSVAsync(byteStream);
  // final cleanData = knn.cleanData(data);
  return knn.predict(item: item);
}
