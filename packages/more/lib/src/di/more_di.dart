import 'package:get_it/get_it.dart';
import 'package:more/src/presentation/cubit/more_cubit.dart';

void configureMoreDependencies(GetIt getIt) {
  if (!getIt.isRegistered<MoreCubit>()) {
    getIt.registerFactory<MoreCubit>(() => MoreCubit());
  }
}
