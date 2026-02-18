import 'dart:async';

import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_local_datasource.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesLocalDataSource _local;
  FavoritesRepositoryImpl(this._local);

  final _controller = StreamController<List<int>>.broadcast();
  List<int> _ids = const [];
  bool _loaded = false;

  Future<void> _ensureLoaded() async {
    if (_loaded) return;
    _ids = await _local.readFavoriteIds();
    _loaded = true;
  }

  @override
  Stream<List<int>> watchIds() async* {
    await _ensureLoaded();
    yield List.unmodifiable(_ids);
    yield* _controller.stream;
  }

  @override
  Future<List<int>> getIds() async {
    await _ensureLoaded();
    return List.unmodifiable(_ids);
  }

  @override
  Future<List<int>> toggle(int id) async {
    await _ensureLoaded();

    if (_ids.contains(id)) {
      _ids = _ids.where((e) => e != id).toList(growable: false);
    } else {
      _ids = [id, ..._ids];
    }

    await _local.writeFavoriteIds(_ids);
    _controller.add(List.unmodifiable(_ids));
    return List.unmodifiable(_ids);
  }
}
