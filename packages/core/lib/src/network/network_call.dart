import '../errors/error_mapper.dart';
import '../result/result.dart';

class NetworkCall {
  static Future<Result<T>> guard<T>(Future<T> Function() block) async {
    try {
      final data = await block();
      return Success<T>(data);
    } catch (e) {
      return FailureResult<T>(ErrorMapper.toFailure(e));
    }
  }
}
