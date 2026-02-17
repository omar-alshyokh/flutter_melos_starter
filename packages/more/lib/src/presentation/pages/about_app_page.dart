import 'package:flutter/material.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About the app')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'This is a starter app.\n\nWe will extend this page later with version, terms, privacy, and more.',
        ),
      ),
    );
  }
}
