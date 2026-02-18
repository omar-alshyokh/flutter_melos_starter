import '../result/result.dart';

abstract class BaseRepository {
  const BaseRepository();

  Result<E> mapObject<D, E>(Result<D> result, E Function(D dto) mapper) {
    return result.when(
      success: (dto) => Success(mapper(dto)),
      failure: (f) => FailureResult(f),
    );
  }

  Result<List<E>> mapList<D, E>(
    Result<List<D>> result,
    E Function(D dto) mapper,
  ) {
    return result.when(
      success: (list) => Success(list.map(mapper).toList(growable: false)),
      failure: (f) => FailureResult(f),
    );
  }
}
