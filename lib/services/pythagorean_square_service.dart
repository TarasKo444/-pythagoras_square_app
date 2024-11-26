import 'dart:convert';

import 'package:flutter/services.dart';

class PythagoreanSquareService {
  Result calculate(DateTime date) {
    final a1 =
        date.day % 10 + date.day ~/ 10 + date.month % 10 + date.month ~/ 10;
    final a2 = date.year % 10 +
        (date.year ~/ 10 % 10) +
        (date.year ~/ 100 % 10) +
        (date.year ~/ 1000 % 10);

    final r1 = a1 + a2;
    final r2 = r1 % 10 + r1 ~/ 10;
    final r3 = r1 - (2 * date.day ~/ 10);
    final r4 = r3 % 10 + r3 ~/ 10;

    final chars =
        _convertToCharList("${date.year}${date.month}${date.day}$r1$r2$r3$r4");

    final matrix = {
      '1': Characteristic(
        char: '1',
        name: 'Character',
        intensity: _count(chars, '1'),
      ),
      '2': Characteristic(
        char: '2',
        name: 'Energy',
        intensity: _count(chars, '2'),
      ),
      '3': Characteristic(
        char: '3',
        name: 'Interests',
        intensity: _count(chars, '3'),
      ),
      '4': Characteristic(
        char: '4',
        name: 'Health',
        intensity: _count(chars, '4'),
      ),
      '5': Characteristic(
        char: '5',
        name: 'Logic',
        intensity: _count(chars, '5'),
      ),
      '6': Characteristic(
        char: '6',
        name: 'Work',
        intensity: _count(chars, '6'),
      ),
      '7': Characteristic(
        char: '7',
        name: 'Luck',
        intensity: _count(chars, '7'),
      ),
      '8': Characteristic(
        char: '8',
        name: 'Duty',
        intensity: _count(chars, '8'),
      ),
      '9': Characteristic(
        char: '9',
        name: 'Memory',
        intensity: _count(chars, '9'),
      ),
    };
    return Result(matrix: matrix);
  }

  dynamic _data;
  Future<String> getNumerologyDescription(Characteristic result) async {
    if (_data == null) {
      final json = await rootBundle.loadString('assets/data/numerology.json');
      _data = jsonDecode(json);
    }

    late String intensityLevel;
    if (result.intensity == 0) {
      intensityLevel = 'none';
    } else if (result.intensity > 5) {
      intensityLevel = 'max';
    } else {
      intensityLevel = result.char * result.intensity;
    }

    final matrixName = result.name.toLowerCase();
    final intensityLevels = _data[matrixName]['intensity_levels'];
    final description =
        intensityLevels[intensityLevel]['description']! as String;

    return description;
  }

  List<String> _convertToCharList(String str) {
    var result = <String>[];
    for (var i = 0; i < str.length; i++) {
      result.add(str[i]);
    }
    return result;
  }

  int _count(List<String> chars, String element) {
    var result = 0;
    for (var i = 0; i < chars.length; i++) {
      if (chars[i] == element) {
        result++;
      }
    }
    return result;
  }
}

class Result {
  Result({required this.matrix});

  Map<String, Characteristic> matrix;
}

class Characteristic {
  Characteristic(
      {required this.name, required this.char, required this.intensity});

  String name;
  String char;
  int intensity;
}
