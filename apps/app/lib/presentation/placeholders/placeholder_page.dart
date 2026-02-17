import 'package:flutter/material.dart';

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Placeholder(child: Text(title));
  }
}
