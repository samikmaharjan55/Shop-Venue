import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_venue/exception/http_exception.dart';
import 'dart:async';

class Auth with ChangeNotifier {
  String? _token; // expire after one hour
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  bool get isAuth {
    return _token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

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
      //print(json.decode(response.body));
      final responseData = json.decode(response.body);
      if (responseData["error"] != null) {
        throw HttpException(responseData["error"]["message"]);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      String userType;
      if (urlSegment == "signUp") {
        userType = await addUserToDatabase(_token!, userId!, email);
      } else {
        userType = await getUser(_token!, _userId!);
      }
      _autoLogout();
      notifyListeners();

      // initialized shared preferences
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String(),
        'email': email,
        'userType': userType,
      });
      prefs.setString("userData", userData);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, "signUp");
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, "signInWithPassword");
  }

  Future<void> logout() async {
    _token = null;
    _expiryDate = null;
    _userId = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) {
      return false;
    }
    final extractedData =
        json.decode(prefs.getString("userData")!) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedData['expiryDate'].toString());
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedData['token'].toString();
    _expiryDate = expiryDate;
    _userId = extractedData['userId'].toString();
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<String> addUserToDatabase(
      String authToken, String userId, String email) async {
    final url =
        "https://shop-venue-344b6-default-rtdb.firebaseio.com/users/$userId.json?auth=$authToken";
    try {
      final response = await http.put(Uri.parse(url),
          body: json.encode({
            'userId': userId,
            'email': email,
            'userType': "client",
          }));
      //print(json.decode(response.body));
      return "client";
    } catch (error) {
      rethrow;
    }
  }

  Future<String> getUser(String authToken, String userId) async {
    final url =
        "https://shop-venue-344b6-default-rtdb.firebaseio.com/users/$userId.json?auth=$authToken";
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      return extractedData["userType"];
    } catch (error) {
      //print(error);
      rethrow;
    }
  }
}
