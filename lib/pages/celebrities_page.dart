import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:pythagoras_square_app/services/celebrities_service.dart';
import 'package:pythagoras_square_app/services/pythagorean_square_service.dart';

class CelebritiesPage extends StatefulWidget {
  const CelebritiesPage({super.key});

  @override
  State<CelebritiesPage> createState() => _CelebritiesPageState();
}

class _CelebritiesPageState extends State<CelebritiesPage> {
  final CelebritiesService _celebritiesService = GetIt.I<CelebritiesService>();

  String? _selectedCountry;

  @override
  Widget build(BuildContext context) {
    final result = Provider.of<Result>(context);
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: FutureBuilder(
        future: _celebritiesService.celebritiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder(
                    future: _celebritiesService.countiresFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 30.0),
                                child: FittedBox(
                                  child: Text(
                                    'Filter by country:',
                                    style: theme.textTheme.displayMedium,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                child: DropdownMenu(
                                  onSelected: (value) {
                                    setState(() {
                                      _selectedCountry = value;
                                    });
                                  },
                                  initialSelection: null,
                                  dropdownMenuEntries: [
                                    const DropdownMenuEntry(
                                        value: null, label: 'Any'),
                                    for (final c in snapshot.data!)
                                      DropdownMenuEntry(value: c, label: c),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: 30),
                  ..._buildColumnBody(result, snapshot.data!, theme),
                ],
              ),
            );
          } else {
            return LoadingAnimationWidget.flickr(
              leftDotColor: theme.colorScheme.primary,
              rightDotColor: theme.colorScheme.onPrimary,
              size: 50,
            );
          }
        },
      ),
    );
  }

  List<Widget> _buildColumnBody(
    Result result,
    List<Celebrity> celebrities,
    ThemeData theme,
  ) {
    final list = <Widget>[];

    for (final r in result.matrix.keys) {
      final filtered = celebrities.where(
        (element) {
          if (_selectedCountry != null && _selectedCountry != element.country) {
            return false;
          }
          return result.matrix[r]!.intensity == element.intensities[r];
        },
      ).toList();
      list.addAll([
        Text(
          'Celebrities with your ${result.matrix[r]!.name.toLowerCase()}',
          style: theme.textTheme.displaySmall!.copyWith(fontSize: 16),
        ),
        const SizedBox(height: 10),
        if (filtered.isNotEmpty)
          CelebritiesList(celebrities: filtered)
        else
          Text('None', style: theme.textTheme.displayMedium),
        const SizedBox(height: 10),
        if (r != '9') const Divider(),
        const SizedBox(height: 10),
      ]);
    }
    return list;
  }
}

class CelebritiesList extends StatelessWidget {
  const CelebritiesList({
    super.key,
    required this.celebrities,
  });

  final List<Celebrity> celebrities;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: celebrities.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Container(
              color: theme.colorScheme.onPrimary.withAlpha(50),
              width: 120,
              child: Center(
                child: Column(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Image(
                        image: AssetImage(
                          'assets/${celebrities[index].imagePath}',
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: FittedBox(
                            child: Text(celebrities[index].name,
                                style: theme.textTheme.displaySmall),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FittedBox(
                            child: Text(
                              celebrities[index].birthdate,
                              style: theme.textTheme.displaySmall,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
