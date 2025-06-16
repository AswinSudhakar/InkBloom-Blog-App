// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inkbloom/api/api.dart';
import 'package:inkbloom/View/authentication/login.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Authservice {
  final client = http.Client();
  String? _token;

  Future<String?> login(String username, String password) async {
    final Map<String, dynamic> body = {
      'username': username,
      'password': password
    };

    try {
      final response = await client.post(
          Uri.parse("${Apis().baseurl}${Apis().authurl}"),
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          body: body);

      // print("Request URL: ${Apis().baseurl}${Apis().authurl}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _token = data['access_token'];

        // print(response.statusCode);
        // print('Response body: ${response.body}');

        // print('the token for your login is : ${_token}');

        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString('token', _token.toString());
      } else {
        print('request failed with status code ${response.statusCode}');
      }
      return _token;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<String?> register(
      String username, String email, String password) async {
    final Map<String, dynamic> body = {
      "name": username,
      "email": email,
      "password": password
    };

    try {
      final response = await client.post(
          Uri.parse("${Apis().baseurl}${Apis().resister}"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body));

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Registration successful.');
        final data = json.decode(response.body);

        final message = data['message'];
        // print(message);
        return message;
      } else {
        print('Registration failed with status code: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> logOut(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove('token');

    await pref.clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
      (route) => false,
    );
  }
}
