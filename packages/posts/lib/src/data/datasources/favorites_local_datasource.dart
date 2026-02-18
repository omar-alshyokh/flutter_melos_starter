import 'package:core/core.dart';

class FavoritesLocalDataSource {
  static const _favoritesKey = 'posts_favorite_ids';

  final AppPrefs _prefs;
  FavoritesLocalDataSource(this._prefs);

  Future<List<int>> readFavoriteIds() async {
    final raw = _prefs.getString(_favoritesKey);
    if (raw == null || raw.trim().isEmpty) return const [];

    return raw
        .split(',')
        .map((e) => int.tryParse(e.trim()))
        .whereType<int>()
        .toList(growable: false);
  }

  Future<void> writeFavoriteIds(List<int> ids) async {
    final encoded = ids.join(',');
    await _prefs.setString(_favoritesKey, encoded);
  }
}
