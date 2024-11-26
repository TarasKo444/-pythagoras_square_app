import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pythagoras_square_app/main.dart';
import 'package:pythagoras_square_app/services/compatibility_service.dart';
import 'package:pythagoras_square_app/utils.dart';

class CompatibilityPage extends StatefulWidget {
  const CompatibilityPage({super.key});

  @override
  State<CompatibilityPage> createState() => _CompatibilityPageState();
}

class _CompatibilityPageState extends State<CompatibilityPage> {
  DateTime? _firstDate;
  DateTime? _secondDate;

  @override
  void initState() {
    super.initState();
    final date = Provider.of<BirthdayModel>(context, listen: false).birthday;
    _firstDate = date;
  }

  final _compatibilityService = GetIt.I<CompatibilityService>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: Flex(
            crossAxisAlignment: CrossAxisAlignment.start,
            direction: Axis.horizontal,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Flex(
                  direction: Axis.vertical,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: _buildButton(
                          (p0) {
                            setState(() {
                              _firstDate = p0;
                            });
                          },
                          'First Date',
                          _firstDate,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        _firstDate != null
                            ? DateFormat('yyyy/MMM/dd').format(_firstDate!)
                            : '',
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Flex(
                  direction: Axis.vertical,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: _buildButton(
                          (p0) {
                            setState(() {
                              _secondDate = p0;
                            });
                          },
                          'Second Date',
                          _secondDate,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        _secondDate != null
                            ? DateFormat('yyyy/MMM/dd').format(_secondDate!)
                            : '',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(60.0),
            child: Center(
              child: Builder(
                builder: (context) {
                  if (_firstDate != null && _secondDate != null) {
                    final l1 = _compatibilityService
                        .calculateLifePathNumber(_firstDate!);
                    final l2 = _compatibilityService
                        .calculateLifePathNumber(_secondDate!);
                    final answer =
                        _compatibilityService.getCompatibility(l1, l2);
                    return Text(
                      answer,
                      style: theme.textTheme.displaySmall,
                      textAlign: TextAlign.center,
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ),
        )
      ],
    );
  }

  SizedBox _buildButton(
      Function(DateTime) onSubmit, String text, DateTime? initDate) {
    return SizedBox(
      width: 200,
      height: 100,
      child: DatePicker(
        onSubmit: onSubmit,
        initialDate: initDate,
        child: Center(
          child: FittedBox(
            child: Text(text),
          ),
        ),
      ),
    );
  }
}
