import 'package:flutter/material.dart';
import '../models/http_exception.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiry;
  String _userId;
  Timer _timer;

  String get token {
    if (_expiry != null && _expiry.isAfter(DateTime.now()) && _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  bool isAuth() {
    return (token != null);
  }

  Future<void> signUp(String email, String password) async {
    return authenticate(email, password, 'signUp');
  }

  Future<void> signIn(String email, String password) async {
    return authenticate(email, password, 'signInWithPassword');
  }

  Future<void> authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCFjMjVIIclopeg8rrT4';
    try {
      final response = await http.post(url,
          body: json.encode({
            'returnSecureToken': true,
            'email': email,
            'password': password,
          }));
      if (json.decode(response.body)['error'] != null) {
        throw HttpException(json.decode(response.body)['error']['message']);
      }
      _expiry = DateTime.now().add(Duration(
          seconds: int.parse(json.decode(response.body)['expiresIn'])));
      _userId = json.decode(response.body)['localId'];
      _token = json.decode(response.body)['idToken'];
    } catch (error) {
      throw error;
    }
    _autoLogout();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode({
      'expiryDate': _expiry.toIso8601String(),
      'userId': _userId,
      'token': token
    });
    prefs.setString('userData', userData);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiry = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  void logout() async {
    _expiry = null;
    _token = null;
    _userId = null;
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    //prefs.clear('userData');
  }

  void _autoLogout() {
    if (_timer != null) {
      _timer.cancel();
    }
    final expTime = _expiry.difference(DateTime.now()).inSeconds;
    _timer = Timer(Duration(seconds: expTime), logout);
  }
}
