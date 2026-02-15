import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  int _indexFromLocation(String location) {
    if (location.startsWith('/posts')) return 1;
    return 0; // auth
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _indexFromLocation(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == 0) context.go('/auth');
          if (index == 1) context.go('/posts');
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.lock), label: 'Auth'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Posts'),
        ],
      ),
    );
  }
}
