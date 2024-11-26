import 'dart:core';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:pythagoras_square_app/pages/first_time_screen.dart';
import 'package:pythagoras_square_app/services/celebrities_service.dart';
import 'package:pythagoras_square_app/services/compatibility_service.dart';
import 'package:pythagoras_square_app/services/pythagorean_square_service.dart';
import 'package:pythagoras_square_app/services/summarization_service.dart';

void main() {
  setup();
  runApp(const MainApp());
}

void setup() {
  GetIt.I.registerFactory<PythagoreanSquareService>(
      () => PythagoreanSquareService());
  GetIt.I.registerFactory<SummarizationService>(() => SummarizationService());
  GetIt.I.registerFactory<CompatibilityService>(() => CompatibilityService());
  GetIt.I.registerSingleton<CelebritiesService>(CelebritiesService());
}

final _themeData = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.purple,
    brightness: Brightness.dark,
  ),
  textTheme: TextTheme(
    displayLarge: GoogleFonts.dmMono(fontSize: 50),
    displayMedium: GoogleFonts.dmMono(fontSize: 40),
    displaySmall: GoogleFonts.dmMono(fontSize: 20),
  ),
);

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    final celebritiesService = GetIt.I<CelebritiesService>();
    celebritiesService.startCelebritiesLoading();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BirthdayModel>(
      create: (BuildContext context) => BirthdayModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: _themeData,
        home: Builder(builder: (context) {
          return const FirstTimeScreen();
        }),
      ),
    );
  }
}

class BirthdayModel extends ChangeNotifier {
  DateTime? _birthday;

  DateTime? get birthday => _birthday;

  void update(DateTime? date) {
    _birthday = date;
    notifyListeners();
  }
}

final class Environment {
  static const aiApiKey = String.fromEnvironment('AI_API_KEY');
}
