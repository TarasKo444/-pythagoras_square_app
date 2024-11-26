import 'dart:convert';

import 'package:flutter/services.dart';

final class CelebritiesService {
  late final Future<List<Celebrity>> celebritiesFuture;
  late final Future<Set<String>> countiresFuture;

  Future startCelebritiesLoading() async {
    final json = await rootBundle.loadString('assets/data/celebrities.json');
    final data = jsonDecode(json);
    celebritiesFuture = (() async => _parse(data))();
    countiresFuture = (() async {
      final list = <String>{};
      for (var c in await celebritiesFuture) {
        list.add(c.country);
      }
      return list;
    })();
  }

  static List<Celebrity> _parse(dynamic data) {
    var list = <Celebrity>[];
    for (var d in data) {
      list.add(Celebrity(
        name: d['name'],
        imagePath: d['imagePath'],
        birthdate: d['birthdate'],
        country: d['country'],
        type: _getTypeFromString(d['type'] as String)!,
        intensities: {
          '1': d['1'],
          '2': d['2'],
          '3': d['3'],
          '4': d['4'],
          '5': d['5'],
          '6': d['6'],
          '7': d['7'],
          '8': d['8'],
          '9': d['9'],
        },
      ));
    }
    return list;
  }

  static CelebrityType? _getTypeFromString(String statusAsString) {
    for (final element in CelebrityType.values) {
      if (element.toString() == 'CelebrityType.$statusAsString') {
        return element;
      }
    }
    return null;
  }
}

final class Celebrity {
  final String name;
  final String country;
  final String birthdate;
  final String imagePath;
  final CelebrityType type;
  final Map<String, int> intensities;

  const Celebrity({
    required this.imagePath,
    required this.birthdate,
    required this.country,
    required this.name,
    required this.intensities,
    required this.type,
  });
}

enum CelebrityType {
  actor,
  singer;
}
