import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:smartconsultor/core/error/failures.dart';
import 'package:smartconsultor/core/error/result.dart';
import 'package:smartconsultor/core/log/log_manager.dart';
import 'package:smartconsultor/core/network/network_info.dart';
import 'package:smartconsultor/core/utils/fingerprint_service.dart';
import 'package:smartconsultor/features/login/data/datasources/local/manage_token_in_mobile_desktop.dart';
import 'package:smartconsultor/features/login/data/datasources/remote/refresh_token_mobile_desktop.dart';
import 'package:smartconsultor/features/login/data/datasources/remote/refresh_token_web.dart';

abstract class TokenRepository {
  Future<Result<Map<String, dynamic>?>> refreshToken(String refeshToken);
}

@Singleton()
class TokenRepositoryImpl implements TokenRepository {
  final ManageTokenInMobileDesktop _manageTokenInMobileDesktop;
  final RefreshTokenWeb _refreshTokenWeb;
  final RefreshTokenMobileDesktop _refreshTokenMobileDesktop;
  final NetworkInfo _networkInfo;

  TokenRepositoryImpl({
    required ManageTokenInMobileDesktop manageTokenInMobileDesktop,
    required RefreshTokenWeb refreshTokenWeb,
    required RefreshTokenMobileDesktop refreshTokenMobileDesktop,
    required NetworkInfo networkInfo,
  })  : _manageTokenInMobileDesktop = manageTokenInMobileDesktop,
        _refreshTokenWeb = refreshTokenWeb,
        _refreshTokenMobileDesktop = refreshTokenMobileDesktop,
        _networkInfo = networkInfo;

  @override
  Future<Result<Map<String, dynamic>?>> refreshToken(String refeshToken) async {
    if (!await _networkInfo.isConnected()) {
      return Left(NetworkFailure(Exception('No Internet Connection')));
    }
    try {
      final result = kIsWeb
          ? await _refreshTokenWeb.refreshToken(refeshToken)
          : await _refreshTokenMobileDesktop.refreshToken(refeshToken);

      if (result == null) {
        return Left(RefreshFailure(Exception('Token is null')));
      }
      if (!kIsWeb) {
        await _manageTokenInMobileDesktop.save(
            await FingerprintService.getFingerprint(), result);
      }

      return Right(result);
    } catch (e, s) {
      LogManager.logError('RefreshToken error', error: e, stackTrace: s);
      return Left(RefreshFailure(e, s));
    }
  }
}
