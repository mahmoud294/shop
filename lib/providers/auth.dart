import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Auth with ChangeNotifier {
  String _token;
  DateTime _dateTime;
  String _userId;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_dateTime != null &&
        _dateTime.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> signIn(String email, String password) async {
    const url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=";
    final response = await http.post(
      url,
      body: json.encode(
          {'email': email, 'password': password, 'returnSecureToken': true}),
    );
    final responseData = json.decode(response.body);
    _token = responseData['idToken'];
    _userId = responseData['localId'];
    _dateTime = DateTime.now().add(
      Duration(
        seconds: int.parse(
          responseData['expiresIn'],
        ),
      ),
    );
    notifyListeners();
  }

  Future<void> signUp(String email, String password) async {
    const url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=";
    final response = await http.post(
      url,
      body: json.encode(
          {'email': email, 'password': password, 'returnSecureToken': true}),
    );
    final responseData = json.decode(response.body);
    _token = responseData['idToken'];
    _userId = responseData['localId'];
    _dateTime = DateTime.now().add(
      Duration(
        seconds: int.parse(
          responseData['expiresIn'],
        ),
      ),
    );
    notifyListeners();
  }
}
