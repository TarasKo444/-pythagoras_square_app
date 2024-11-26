import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:pythagoras_square_app/services/pythagorean_square_service.dart';
import 'package:pythagoras_square_app/services/summarization_service.dart';

class ResultsPage extends StatefulWidget {
  const ResultsPage({super.key});

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  int? _hovered;
  String? _summarizedText;

  Future<String>? _currentDescription;

  final summarizationService = GetIt.I<SummarizationService>();
  final pSService = GetIt.I<PythagoreanSquareService>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final result = Provider.of<Result>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      child: Center(
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double size = constraints.maxWidth > constraints.maxHeight
                      ? constraints.maxHeight
                      : constraints.maxWidth;
                  print(constraints.minWidth);
                  return Center(
                    child: _buildTable(size / 3, context, result),
                  );
                },
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _currentDescription == null
                        ? Text(
                            textAlign: TextAlign.center,
                            'Click on characteristic to get more details',
                            style: theme.textTheme.displaySmall,
                          )
                        : FutureBuilder(
                            future: _currentDescription,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return SingleChildScrollView(
                                  child: SelectableText(
                                    snapshot.data!,
                                    textAlign: TextAlign.start,
                                    style: theme.textTheme.displaySmall!
                                        .copyWith(fontSize: 15),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 300),
                child: OutlinedButton(
                  onPressed: () {
                    var future = _summarizedText == null
                        ? summarizationService.summarize(result).then((r) {
                            setState(() {
                              _summarizedText = r;
                            });
                            return r;
                          })
                        : () async {
                            return _summarizedText!;
                          }();

                    _showSummarizeWidget(context, future);
                  },
                  child: const Text('Summarize with AI'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<dynamic> _showSummarizeWidget(
    BuildContext context,
    Future<String> future,
  ) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            return SizedBox(
              height: 600,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        if (snapshot.connectionState == ConnectionState.done)
                          Builder(builder: (context) {
                            return SelectableText(
                              snapshot.data!,
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                    fontSize: 15,
                                  ),
                            );
                          })
                        else
                          LoadingAnimationWidget.waveDots(
                            color: Colors.white,
                            size: 40,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTable(
    double itemSize,
    BuildContext context,
    Result result,
  ) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displaySmall!.copyWith(fontSize: 12);
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: theme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withAlpha(80),
                blurRadius: 6.0,
                spreadRadius: 0.0,
              ),
            ],
          ),
          width: itemSize * 3,
          height: itemSize * 3,
        ),
        Table(
          border: TableBorder.all(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(10)),
          columnWidths: <int, TableColumnWidth>{
            0: FixedColumnWidth(itemSize),
            1: FixedColumnWidth(itemSize),
            2: FixedColumnWidth(itemSize),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: _buildRows(result, itemSize, style),
        ),
      ],
    );
  }

  Widget _tableCell(
    Characteristic result,
    double itemSize,
    TextStyle style,
  ) {
    return Builder(builder: (context) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onLongPressDown: (d) {
          var parsed = int.parse(result.char);
          setState(() {
            if (_hovered == parsed) {
              _currentDescription = null;
              _hovered = null;
            } else {
              _hovered = parsed;
              _currentDescription = pSService.getNumerologyDescription(result);
            }
          });
        },
        child: SizedBox(
          width: itemSize,
          height: itemSize,
          child: Stack(
            children: [
              if (_hovered == int.parse(result.char))
                Transform.scale(
                  scale: 1.1,
                  child: AvatarGlow(
                    glowColor: Theme.of(context).colorScheme.onPrimary,
                    duration: const Duration(milliseconds: 1000),
                    glowShape: BoxShape.rectangle,
                    glowBorderRadius: BorderRadius.circular(10),
                    glowRadiusFactor: 0.2,
                    repeat: true,
                    child: SizedBox(
                      width: itemSize,
                      height: itemSize,
                    ),
                  ),
                ),
              Padding(
                padding: EdgeInsets.only(top: itemSize / 12),
                child: FittedBox(
                  child: SizedBox(
                    width: itemSize,
                    child: Text(
                      result.name,
                      textAlign: TextAlign.center,
                      style: style,
                    ),
                  ),
                ),
              ),
              Center(
                child: FittedBox(
                  child: Text(
                    result.intensity != 0
                        ? result.char * result.intensity
                        : 'none',
                    style: style.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: result.intensity != 0
                          ? Theme.of(context).colorScheme.onSurface
                          : Theme.of(context).colorScheme.surfaceBright,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  List<TableRow> _buildRows(Result result, double itemSize, TextStyle style) {
    var rows = <TableRow>[];
    for (int i = 0; i < 3; i++) {
      var row = TableRow(
        children: <Widget>[
          for (int j = 0; j < 3; j++)
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: _tableCell(
                result.matrix['${i + 1 + j * 3}']!,
                itemSize,
                style,
              ),
            ),
        ],
      );
      rows.add(row);
    }
    return rows;
  }
}
