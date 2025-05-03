// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/login/data/datasources/local/manage_token_in_mobile_desktop.dart'
    as _i361;
import '../../features/login/data/datasources/remote/refresh_token_mobile_desktop.dart'
    as _i578;
import '../../features/login/data/datasources/remote/refresh_token_web.dart'
    as _i1073;
import '../../features/login/data/repositories/background/token_repository.dart'
    as _i193;
import '../../features/login/domain/background/refresh_token_service.dart'
    as _i102;
import '../network/network_info.dart' as _i932;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i193.TokenRepositoryImpl>(() => _i193.TokenRepositoryImpl(
          manageTokenInMobileDesktop: gh<_i361.ManageTokenInMobileDesktop>(),
          refreshTokenWeb: gh<_i1073.RefreshTokenWeb>(),
          refreshTokenMobileDesktop: gh<_i578.RefreshTokenMobileDesktop>(),
          networkInfo: gh<_i932.NetworkInfo>(),
        ));
    gh.factory<_i102.RefreshTokenService>(
        () => _i102.RefreshTokenService(gh<_i193.TokenRepository>()));
    return this;
  }
}
