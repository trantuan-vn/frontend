import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:smartconsultor/features/login/data/repositories/background/token_repository.dart';

class RefreshTokenService {
  Timer? _timer;
  final TokenRepository tokenRepository;

  RefreshTokenService(this.tokenRepository);

  void start(Map<String, dynamic> token) {
    _timer?.cancel();
    final expiresIn = token['expiresDateTime'] - 30; // refresh trước 30s
    _timer = Timer.periodic(Duration(seconds: expiresIn), (_) async {
      final newToken =
          await tokenRepository.refreshToken(token['refreshToken']);
      // lưu lại token mới
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }
}
