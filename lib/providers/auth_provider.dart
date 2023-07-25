import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_venue/exception/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token; // expire after one hour
  DateTime? _expiryDate;
  String? _userId;

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBRXax2aaP11XkRdg9rWVnRECtlXz1K7TU";
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'email': email.trim(),
            'password': password,
            'returnSecureToken': true,
          }));
      print(json.decode(response.body));
      final responseData = json.decode(response.body);
      if (responseData["error"] != null) {
        throw HttpException(responseData["error"]["message"]);
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, "signUp");
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, "signInWithPassword");
  }
}
