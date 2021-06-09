import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:utility_repository/src/local_storage_helper.dart';
import 'package:utility_repository/src/verification_exception.dart';

///Class for handling post and get requests
class HttpMethods {
  static const String server = "https://coci.result.si";
  static const String loginRoute = "/login";
  static const String contractsRoute = "/app/getContracts";
  static const int timeoutDuration = 3; //v sekundah

  static Future<dynamic> httpPostRequest(
      String method, Map<String, dynamic> jsonBody) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final response = await http
        .post(
      Uri.parse(server + method),
      headers: headers,
      body: jsonEncode(jsonBody),
    )
        .timeout(const Duration(seconds: timeoutDuration), onTimeout: () {
      //return null;
      throw TimeoutException("Request timeout after " + timeoutDuration.toString() + " sec.");
    });

    return response;
  }

  ///Handle get request with Bearer token
  static Future<dynamic> httpGetRequest(String method, String token) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final response = await http
        .get(Uri.parse(server + method), headers: headers)
        .timeout(const Duration(seconds: timeoutDuration), onTimeout: () {
      // return null;
      //return http.Response("{}", 401);
      throw TimeoutException("Request timeout after " + timeoutDuration.toString() + " sec.");
    });

    return response;

  }

  ///User login with username and password
  static Future<dynamic> login(String username, String password) async {
    Map<String, dynamic> map = {};
    map['username'] = username;
    map['password'] = password;

    dynamic response = await httpPostRequest(loginRoute, map);

    ///200 - ok
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return jsonDecode(response);
  }

  ///Request contracts
  static Future<dynamic> getContracts(String token) async {
    dynamic response = await httpGetRequest(contractsRoute, token);

    final body = jsonDecode(response.body);
    switch (response.statusCode) {
      case 200:
        await LocalStorageHelper.setContracts(body);
        //print(await LocalStorageHelper.getContracts());
        return body;

      case 401: //token expired
        throw VerificationException(body['Message']);
        //return 0;
    //logout?
    }

    return response;
  }
}
