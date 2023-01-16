import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'data.dart' as data;

import 'package:predictor/predictor.dart';

import 'csv.dart';

const neededAttributes = [
  "Acceleration",
  "Aggression",
  "Agility",
  "Balance",
  "Ball control",
  "Composure",
  "Crossing",
  "Curve",
  "Dribbling",
  "Finishing",
  "Free kick accuracy",
  "GK diving",
  "GK handling",
  "GK kicking",
  "GK positioning",
  "GK reflexes",
  "Heading accuracy",
  "Interceptions",
  "Jumping",
  "Long passing",
  "Long shots",
  "Marking",
  "Penalties",
  "Positioning",
  "Reactions",
  "Short passing",
  "Shot power",
  "Sliding tackle",
  "Sprint speed",
  "Stamina",
  "Standing tackle",
  "Strength",
  "Vision",
  "Volleys",
  "Preferred Positions",
];

final positionCol = neededAttributes.last;

Stream<Map<String, dynamic>> cleanData(Stream<Map<String, dynamic>> source) {
  late StreamSubscription subscription;
  final controller = StreamController<Map<String, dynamic>>(
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
  subscription = source.listen(
    (row) {
      final newMap = Map.fromEntries(
        row.entries.where(
          (element) => neededAttributes.contains(element.key),
        ),
      ).map((key, value) {
        if (double.tryParse(value) != null) {
          value = double.parse(value);
        } else if (int.tryParse(value) != null) {
          value = int.parse(value);
        }
        if (key == positionCol) {
          final positions = (value as String).split(" ");
          value = positions[0];
        }
        return MapEntry(key, value);
      });
      controller.add(newMap);
    },
    onDone: () {
      controller.close();
    },
    onError: (error, stackTrace) {
      controller.addError(error, stackTrace);
    },
  );
  return controller.stream;
}

double getDistance(Map<String, dynamic> first, Map<String, dynamic> second) {
  final differencesSquared =
      first.keys.where((key) => key != positionCol).map((e) {
    final firstValue = first[e];
    final secondValue = second[e];
    if (firstValue is! num || secondValue is! num) {
      return 0;
    }
    return math.pow((firstValue - secondValue), 2);
  });
  final sumOfDifferences =
      differencesSquared.reduce((value, element) => value + element);
  return math.sqrt(sumOfDifferences);
}

Future<String> predict({
  required Map<String, dynamic> item,
  // required List<Map<String, dynamic>> cleanData,
  int k = 35,
}) async {
  final withDistance = data.data.map((e) {
    return MapEntry(getDistance(e, item), e);
  }).toList();
  withDistance.sort(
    (a, b) {
      return ((a.key - b.key) * 1000000).toInt();
    },
  );
  final counted = <String, int>{};
  final firstK = withDistance.take(k);
  for (final distance in firstK) {
    final position = distance.value[positionCol];
    // print("Distance: $distance   Position: $position");
    counted[position] = (counted[position] ?? 0) + 1;
  }
  return counted.entries.reduce((value, element) {
    if (value.value > element.value) {
      return value;
    }
    return element;
  }).key;
}

Future<void> train({
  required double trainSplit,
  required double testSplit,
  required List<Map<String, dynamic>> cleanData,
}) async {
  cleanData.shuffle();
  final trainSize = (trainSplit * cleanData.length).toInt();
  final testSize = cleanData.length - trainSize;
  print("Train Size: $trainSize. Test size: $testSize");
  final trainSet = cleanData.sublist(0, trainSize);
  final testSet = cleanData.sublist(trainSize, cleanData.length);

  final random = testSet[math.Random().nextInt(testSet.length)];
  print("Random item: $random");
  final prediction = await predict(item: random);
  print("\nPrediction: $prediction");
}

const uniquePositions = {
  "ST",
  "LW",
  "RW",
  "GK",
  "CDM",
  "CM",
  "CB",
  "RM",
  "CAM",
  "LM",
  "LB",
  "CF",
  "RB",
  "RWB",
  "LWB",
};

void main() async {
  final file = File("CompleteDataset.csv");
  final bytesStream = file.openRead();
  final rows = await parseCSVAsync(bytesStream).toList();
  final uniquePositions = rows
      .map((e) => e[positionCol] as String)
      .map((e) => e.split(" "))
      .reduce((value, element) => value + element)
      .toSet();
  print(uniquePositions);
  // final cleanData1 = cleanData(data);
  // final rows = await cleanData1.toList();
  // final string = JsonEncoder.withIndent(null).convert(rows);
  // final output = File("data.dart");
  // output.writeAsStringSync(string);
  // Stopwatch stopwatch = Stopwatch()..start();
  // await train(
  //     trainSplit: 0.7, testSplit: 0.3, cleanData: await cleanData1.toList());
  // print("Took: ${stopwatch.elapsed}");
  // await predict(item: {

  // }, cleanData: await cleanData.toList());
}
