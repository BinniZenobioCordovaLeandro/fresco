import 'package:flutter/material.dart';

class TextComponent extends StatelessWidget {
  final String data;

  const TextComponent({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
    );
  }
}
