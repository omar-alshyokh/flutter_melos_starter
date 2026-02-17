// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:app/di/app_module.dart' as _i522;
import 'package:app/di/modules/network_module.dart' as _i926;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    final networkModule = _$NetworkModule();
    gh.lazySingleton<DateTime>(() => appModule.now);
    gh.lazySingleton<_i361.Dio>(() => networkModule.dio());
    return this;
  }
}

class _$AppModule extends _i522.AppModule {}

class _$NetworkModule extends _i926.NetworkModule {}
