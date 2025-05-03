import 'package:smartconsultor/core/keycloak/keycloak_service.dart';
import 'package:smartconsultor/features/splash/data/datasources/remote/auth_remote_datasource.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final KeycloakService keycloakService;

  AuthRemoteDataSourceImpl(this.keycloakService);

  @override
  Future<bool> isAuthenticated() async {
    return keycloakService.isLoggedIn;
  }
}
