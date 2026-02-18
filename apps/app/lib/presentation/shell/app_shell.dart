import 'package:app/routing/feature_entry.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  final List<FeatureEntry> items;
  const AppShell({super.key, required this.child, required this.items});

  int _indexFromLocation(String location, List<FeatureEntry> items) {
    final idx = items.indexWhere(
      (i) => location == i.path || location.startsWith('${i.path}/'),
    );
    return idx < 0 ? 0 : idx;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final currentIndex = _indexFromLocation(location, items);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (i) => context.go(items[i].path),
        destinations: [
          for (final item in items)
            NavigationDestination(icon: Icon(item.icon), label: item.label),
        ],
      ),
    );
  }
}
