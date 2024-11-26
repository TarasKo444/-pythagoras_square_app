import 'package:flutter/material.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pythagoras_square_app/main.dart';
import 'package:pythagoras_square_app/pages/home_screen.dart';
import 'package:pythagoras_square_app/utils.dart';

class FirstTimeScreen extends StatefulWidget {
  const FirstTimeScreen({
    super.key,
  });

  @override
  State<FirstTimeScreen> createState() => _FirstTimeScreenState();
}

class _FirstTimeScreenState extends State<FirstTimeScreen> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Center(
          child: Container(
            color: theme.colorScheme.surface,
            width: 300,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 50,
                ),
                child: Column(
                  children: [
                    const Flexible(
                      flex: 3,
                      child: _Top(),
                    ),
                    const Spacer(flex: 1),
                    Flexible(
                      flex: 4,
                      child: _Middle(
                        onChanged: (DateTime date) {
                          setState(() {
                            _selectedDate = date;
                          });
                        },
                        date: _selectedDate,
                      ),
                    ),
                    const Spacer(flex: 1),
                    Flexible(
                      flex: 3,
                      child: Wrap(
                        children: [
                          if (_selectedDate != null)
                            _Bottom(date: _selectedDate)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _Bottom extends StatelessWidget {
  const _Bottom({
    required this.date,
  });

  final DateTime? date;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: SwipeButton.expand(
        thumb: const Icon(
          Icons.double_arrow_rounded,
          color: Colors.white,
        ),
        activeThumbColor: theme.colorScheme.onPrimary,
        activeTrackColor: theme.colorScheme.surfaceContainer,
        onSwipe: () {
          var counter = context.read<BirthdayModel>();
          counter.update(date);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const HomeScreen();
              },
            ),
          );
        },
        child: Text(
          "Swipe to continue",
          style: TextStyle(
            color: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

class _Middle extends StatefulWidget {
  const _Middle({
    required this.onChanged,
    this.date,
  });

  final Function(DateTime time) onChanged;
  final DateTime? date;

  @override
  State<_Middle> createState() => _MiddleState();
}

class _MiddleState extends State<_Middle> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: LayoutBuilder(builder: (context, constraints) {
        return Column(
          children: [
            Expanded(
              flex: 2,
              child: SizedBox(
                width: constraints.maxWidth,
                child: DatePicker(
                  initialDate: widget.date,
                  onSubmit: widget.onChanged,
                  child: SizedBox.expand(
                    child: LayoutBuilder(builder: (context, constraints) {
                      return Padding(
                        padding: EdgeInsets.all(constraints.maxWidth * 0.3),
                        child: const FittedBox(
                          fit: BoxFit.cover,
                          child: Icon(
                            Icons.edit_calendar_outlined,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
            if (widget.date != null)
              Expanded(
                child: SizedBox(
                  child: Center(
                    child: Builder(builder: (context) {
                      if (widget.date != null) {
                        final year = widget.date!.year;
                        final month = DateFormat('MMMM')
                            .format(DateTime(0, widget.date!.month));
                        final day = widget.date!.day;
                        return Text(
                          '$year/$month/$day',
                          style: theme.textTheme.displaySmall,
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
}

class _Top extends StatelessWidget {
  const _Top();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayLarge = theme.textTheme.displayLarge!
        .copyWith(color: theme.colorScheme.onSurface);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: displayLarge,
            children: [
              const TextSpan(text: 'Enter your '),
              WidgetSpan(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextWithCustomUnderline(
                        text: 'birthdate',
                        style: displayLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        underline: Container(
                          color: theme.colorScheme.primary,
                          height: 1,
                        ),
                        offset: const Offset(0, 5),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
