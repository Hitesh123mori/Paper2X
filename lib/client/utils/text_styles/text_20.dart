import 'package:flutter/material.dart';

class Text20 extends StatelessWidget {
  final String text;
  final bool? isBold;
  final bool? isWhite;

  const Text20({
    super.key,
    required this.text,
    this.isBold,
    this.isWhite,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      softWrap: true,
      style: TextStyle(
        fontSize: 20,
        fontWeight: (isBold ?? true) ? FontWeight.bold : FontWeight.normal,
        color: (isWhite ?? false) ? Colors.white : Colors.black,
      ),
    );
  }
}