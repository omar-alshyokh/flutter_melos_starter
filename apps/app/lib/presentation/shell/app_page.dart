import 'package:core/core.dart';
import 'package:flutter/material.dart';

class AppPage extends StatelessWidget {
  final String title;
  final Widget child;

  const AppPage({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: Padding(padding: AppSpacing.page, child: child),
      ),
    );
  }
}
