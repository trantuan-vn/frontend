import 'package:smartconsultor/core/error/result.dart';

abstract class AuthRepository {
  Future<Result<bool>> login();
}
