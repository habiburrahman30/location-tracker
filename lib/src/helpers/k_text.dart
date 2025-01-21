import 'package:flutter/material.dart';

// ignore: must_be_immutable
class KText extends StatelessWidget {
  final String? text;
  final Color? color;
  final double? fontSize;
  final TextAlign? textAlign;

  TextOverflow textOverflow;
  final int? maxLines;
  final bool? bold;

  KText({
    super.key,
    required this.text,
    this.color,
    this.bold = false,
    this.fontSize,
    this.textAlign,
    this.maxLines,
    this.textOverflow = TextOverflow.ellipsis,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '$text',
      textScaler: TextScaler.linear(1.0),
      style: TextStyle(
        decoration: TextDecoration.none,
        fontSize: fontSize != null ? fontSize! : 14,
        color: color != null ? color : Colors.black,
        fontWeight: bold! ? FontWeight.bold : FontWeight.normal,
      ),
      maxLines: maxLines,
      overflow: textOverflow,
      textAlign: textAlign != null ? textAlign : TextAlign.start,
    );
  }
}
