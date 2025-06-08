import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GeoGatewayResolverService {
  static const fallbackGateway = 'wss://global-gateway.example.com';

  static const regionMap = {
    'AS': 'wss://asia.example.com',
    'EU': 'wss://europe.example.com',
    'NA': 'wss://na.example.com',
    'AF': 'wss://africa.example.com',
    'OC': 'wss://oceania.example.com',
  };

  static Future<String> getGatewayUrl() async {
    final prefs = await SharedPreferences.getInstance();

    // Use cache if exists
    final cached = prefs.getString('cached_gateway');
    if (cached != null) return cached;

    final region = await _resolveRegion();

    final url = regionMap[region] ?? fallbackGateway;
    await prefs.setString('cached_gateway', url);
    return url;
  }

  static Future<String?> _resolveRegion() async {
    final apis = [
      'http://ip-api.com/json',
      'https://ipwho.is/',
      'https://ipinfo.io/json',
      'https://ipapi.co/json',
      'https://get.geojs.io/v1/ip/geo.json',
    ];

    for (final api in apis) {
      try {
        final res =
            await http.get(Uri.parse(api)).timeout(Duration(seconds: 2));
        final json = jsonDecode(res.body);

        // Tùy API → extract đúng field
        final continent = json['continentCode'] ??
            json['continent_code'] ??
            json['continent'] ??
            json['region'] ??
            json['continent_name'];
        if (continent != null && continent is String)
          return continent.toUpperCase();
      } catch (_) {
        continue;
      }
    }
    return null;
  }
}
