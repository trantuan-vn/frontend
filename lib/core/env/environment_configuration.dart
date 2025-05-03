import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvironmentConfiguration {
  static final EnvironmentConfiguration _instance =
      EnvironmentConfiguration._internal();

  // Singleton factory
  factory EnvironmentConfiguration() => _instance;

  EnvironmentConfiguration._internal();

  // Keycloak configuration variables
  String keycloakIssuer = '';
  String keycloakClientId = '';
  String keycloakRedirectUri = '';
  String keycloakRedirectUriWeb = '';
  String keycloakScopes = '';
  String keycloakAuthorizationEndpoint = '';
  String keycloakTokenEndpoint = '';
  String keycloakEndSessionEndpoint = '';
  String keycloakUserinfoEndpoint = '';
  String keycloakJwksUri = '';

  // Initialize the configuration
  Future<void> initialize() async {
    final env = kReleaseMode
        ? 'production'
        : (kProfileMode ? 'staging' : 'development');

    String envFileName = '$env.env';
    final dotEnv = DotEnv();
    await dotEnv.load(fileName: envFileName);

    // Assign Keycloak configuration values from .env
    keycloakIssuer = dotEnv.env['KEYCLOAK_ISSUER'] ?? '';
    keycloakClientId = dotEnv.env['KEYCLOAK_CLIENT_ID'] ?? '';
    keycloakRedirectUri = dotEnv.env['KEYCLOAK_REDIRECT_URI'] ?? '';
    keycloakRedirectUriWeb = dotEnv.env['KEYCLOAK_REDIRECT_URI_WEB'] ?? '';
    keycloakScopes = dotEnv.env['KEYCLOAK_SCOPES'] ?? '';
    keycloakAuthorizationEndpoint =
        dotEnv.env['KEYCLOAK_AUTHORIZATION_ENDPOINT'] ?? '';
    keycloakTokenEndpoint = dotEnv.env['KEYCLOAK_TOKEN_ENDPOINT'] ?? '';
    keycloakEndSessionEndpoint =
        dotEnv.env['KEYCLOAK_END_SESSION_ENDPOINT'] ?? '';
    keycloakUserinfoEndpoint = dotEnv.env['KEYCLOAK_USERINFO_ENDPOINT'] ?? '';
    keycloakJwksUri = dotEnv.env['KEYCLOAK_JWKS_URI'] ?? '';
  }
}
