import 'dart:convert';

import 'package:apicallslegend/models/login_response.dart';
import 'package:apicallslegend/models/user.dart';
import 'package:apicallslegend/utils/commons.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:async';

class LoginProvider extends ChangeNotifier {
  LoginResponse _loginResponse;

  Future<LoginResponse> loginUser(String phone, String password) async {
    try {
      final response = await http.post(
        Commons.apiBaseURL + "login",
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
        },
        body:
            jsonEncode(<String, String>{'phone': phone, 'password': password}),
      );
      if (response.statusCode == 200) {
        var responseJson = Commons.returnResponse(response);
        _loginResponse = LoginResponse.fromJson(responseJson);
        return _loginResponse;
      } else {
        print(response.statusCode);
        return null;
      }
    } on SocketException {
      return null;
    }
  }
}
