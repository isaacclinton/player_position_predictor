import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';

const defaultEol = "\n";
const defaultFieldDelimiter = ",";

Stream<List<String>> getLineStreamFromByteStream(
  Stream<List<int>> bytesStream,
) {
  late StreamSubscription subscription;
  final controller = StreamController<List<String>>(
    onCancel: () {
      subscription.cancel();
    },
    onPause: () {
      subscription.pause();
    },
    onResume: () {
      subscription.resume();
    },
  );
  final buffer = StringBuffer();
  subscription = bytesStream.listen(
    (event) {
      for (final byte in event) {
        if (byte == defaultEol.codeUnits[0]) {
          final string = buffer.toString();
          final values = string.split(defaultFieldDelimiter);
          controller.add(values);
          buffer.clear();
        } else {
          buffer.write(String.fromCharCode(byte));
        }
      }
    },
    onError: (error, stackTrace) {
      controller.addError(error, stackTrace);
    },
    onDone: () {
      controller.close();
    },
  );
  return controller.stream;
}

Stream<Map<String, dynamic>> parseCSVAsync(Stream<List<int>> bytesStream) {
  int linesCount = 0;
  late StreamSubscription bytesSubscription;
  late List<String> headings;
  final controller = StreamController<Map<String, dynamic>>(
    onPause: () {
      bytesSubscription.pause();
    },
    onResume: () {
      bytesSubscription.resume();
    },
    onCancel: () {
      bytesSubscription.cancel();
    },
  );

  final lineStream = getLineStreamFromByteStream(bytesStream);
  bytesSubscription = lineStream.listen(
    (line) {
      if (linesCount == 0) {
        try {
          headings = line.map((e) => e).toList();
        } catch (e) {
          print(line);
          rethrow;
        }
      } else {
        final map = headings
            .mapIndexed((index, element) => MapEntry(element, line[index]));
        controller.add(Map.fromEntries(map));
      }
      linesCount++;
    },
    onDone: () {
      controller.close();
    },
    onError: (error, stacktrace) {
      controller.addError(error, stacktrace);
    },
    cancelOnError: true,
  );
  return controller.stream;
}

void main() async {
  
}
