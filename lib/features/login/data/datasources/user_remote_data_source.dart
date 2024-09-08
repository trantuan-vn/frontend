import 'dart:convert';

import 'package:smartconsultor/core/error/exceptions.dart';
import 'package:smartconsultor/features/login/data/models/user_model.dart';
import 'package:http/http.dart' as http;



abstract class UserRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<UserModel> login(String username, String password);

}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;
  UserRemoteDataSourceImpl({required this.client});
  @override
  Future<UserModel> login(String username, String password) => _getUserFromUrl('http://localhost:8081/api/login');
  
  Future<UserModel> _getUserFromUrl(String url) async {
    /*
    final uri=Uri.parse(url);
    final response = await client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
    */
    String jsonString = '''
    {
      "access_token": "accessToken",
      "refresh_token": "refreshToken",
      "user_id": "1",
      "full_name": "tuanta",
      "email": "tuanta@vsd.vn",
      "phone_number": "0919358683",
      "birth_date": "2024-02-01 12:34:56.789",
      "gender": "male",
      "country": "Vietnam",
      "address": "",
      "roles": "role1,role2",
      "email_verified": true,
      "avatar_url": "avatarUrl",
      "recent_devices": "iphone1,iphone2",
      "access_token_expiration": "2024-02-06 12:34:56.789",
      "refresh_token_expiration": "2024-02-06 12:34:56.789",
      "encryption_key": "encryptionKey"
    }
    ''';

    return UserModel.fromJson(json.decode(jsonString));
  }

}
