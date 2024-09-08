import 'package:flutter_dotenv/flutter_dotenv.dart';
//import 'dart:io';
//import 'package:path_provider/path_provider.dart';
//import 'package:path/path.dart' as pathlib;
//import 'package:parse_server_sdk/parse_server_sdk.dart'; 

class EnvironmentConfiguration {
  static Future run() async {
    //await dotenv.load(fileName: ".env");
    bool isProduction = const bool.fromEnvironment('dart.vm.product', defaultValue: false);
    String envFileName = isProduction ? "production.env" : "development.env";
    
    //Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    //String path=appDocumentsDirectory.path;
    //String filePath = pathlib.join(path, envFileName);
    await DotEnv().load(fileName: envFileName);
    //final dotEnv = DotEnv();
    // Initialize parse for consuming API service
    // await Parse().initialize(
    //   dotEnv.env['PARSE_APPLICATION_ID']!,
    //   dotEnv.env['BASE_URL']!,
    //   clientKey: dotEnv.env['PARSE_CLIENT_ID'],
    //   masterKey: dotEnv.env['PARSE_MASTER_KEY'], // Required for Back4App and others
    //   autoSendSessionId: true, // Required for authentication and ACL
    //   debug: !isProduction,
    // );
  }
}