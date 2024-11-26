import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:pythagoras_square_app/main.dart';
import 'package:pythagoras_square_app/pages/celebrities_page.dart';
import 'package:pythagoras_square_app/pages/compatibility_pages.dart';
import 'package:pythagoras_square_app/pages/results_page.dart';
import 'package:pythagoras_square_app/services/pythagorean_square_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final pSService = GetIt.I<PythagoreanSquareService>();

  @override
  Widget build(BuildContext context) {
    final date = Provider.of<BirthdayModel>(context, listen: false).birthday;
    final result = pSService.calculate(date!);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Psychomatrix',
          style: theme.textTheme.displaySmall,
        ),
        centerTitle: true,
      ),
      body: Provider<Result>(
        create: (_) => result,
        child: _buildBody(result),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        selectedFontSize: 20,
        selectedIconTheme: IconThemeData(
          color: theme.colorScheme.onPrimaryContainer,
          size: 40,
        ),
        selectedItemColor: theme.colorScheme.onPrimaryContainer,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: _bottomBarItems,
      ),
    );
  }

  final pages = const <Widget>[
    ResultsPage(),
    CelebritiesPage(),
    CompatibilityPage(),
  ];

  Widget _buildBody(Result result) {
    return IndexedStack(
      index: _selectedIndex,
      children: pages,
    );
  }

  List<BottomNavigationBarItem> get _bottomBarItems {
    return const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.psychology),
        label: 'Results',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.people),
        label: 'Celebrities',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.compare_arrows),
        label: 'Compatability',
      ),
    ];
  }
}
