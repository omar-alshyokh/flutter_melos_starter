import 'package:app/routing/feature_entry.dart';
import 'package:app/routing/feature_registry.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  int _indexFromLocation(String location, List<FeatureEntry> items) {
    final index = items.indexWhere(
          (i) => location == i.path || location.startsWith('${i.path}/'),
    );
    return index < 0 ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    final items = featureRegistry(); // ONLY shell tabs
    final location = GoRouterState.of(context).uri.path;
    final currentIndex = _indexFromLocation(location, items);

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: Colors.blue,
        onTap: (i) => context.go(items[i].path),
        items: [
          for (final item in items)
            BottomNavigationBarItem(
              icon: Icon(item.icon),
              label: item.label,
              backgroundColor: Colors.red,
            ),
        ],
      ),
    );
  }
}
