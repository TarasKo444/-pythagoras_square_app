import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/material.dart';

class TextWithCustomUnderline extends StatelessWidget {
  const TextWithCustomUnderline({
    super.key,
    required this.text,
    required this.underline,
    required this.offset,
    this.style,
  });

  final String text;
  final Widget underline;
  final Offset offset;
  final TextStyle? style;

  Size textWidgetSize() {
    final span = TextSpan(text: text, style: style);

    final textPainter = TextPainter(
      text: span,
      maxLines: 1,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    return textPainter.size;
  }

  @override
  Widget build(BuildContext context) {
    final size = textWidgetSize();
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Text(
          textAlign: TextAlign.center,
          text,
          style: style,
        ),
        Positioned(
          width: size.width,
          left: offset.dx,
          top: size.height + offset.dy,
          child: underline,
        )
      ],
    );
  }
}

class DatePicker extends StatelessWidget {
  const DatePicker({
    super.key,
    required this.onSubmit,
    this.initialDate,
    this.child,
  });

  final Function(DateTime) onSubmit;
  final DateTime? initialDate;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton(
      style: ButtonStyle(
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(color: theme.colorScheme.primary),
          ),
        ),
      ),
      onPressed: () {
        BottomPicker.date(
          backgroundColor: theme.colorScheme.surface,
          pickerTextStyle: theme.textTheme.bodyMedium!.copyWith(
            color: theme.colorScheme.onSurface,
          ),
          buttonSingleColor: theme.colorScheme.primary,
          buttonContent: Center(
            child: Text(
              'Select',
              style: theme.textTheme.bodyMedium!.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ),
          onSubmit: (p0) {
            final date = p0 as DateTime;
            onSubmit(date);
          },
          dismissable: true,
          minDateTime: DateTime(1800),
          maxDateTime: DateTime(2050),
          initialDateTime: initialDate ?? DateTime.now(),
          height: MediaQuery.sizeOf(context).height / 2,
          pickerTitle: const Center(child: Text('Pick date')),
        ).show(context);
      },
      child: child,
    );
  }
}
