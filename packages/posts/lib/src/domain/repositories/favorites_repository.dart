abstract class FavoritesRepository {
  Stream<List<int>> watchIds();
  Future<List<int>> getIds();
  Future<List<int>> toggle(int id);
}
