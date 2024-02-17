import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transport_app/main.dart';
import 'package:transport_app/models/user.dart';

class UserLogin {
  static const String baseUrl =
      "https://api.horansoftware.com/api/public/api/auth/login";

  Future<bool> login(String phone, String password) async {
    // hive box implementation
    await Hive.openBox<String>(tokenHive);
    await Hive.openBox<String>(pin_code);
    final Box<String> tokenBox = Hive.box<String>(tokenHive);
    final Box<String> pinBox = Hive.box<String>(pin_code);
      print(
          'inside login service try block ========>${phone} ${password}=========');

    try {

      Map<String, dynamic> data = {
        "phone": phone,
        "password": password,
      };
      final response = await http.post(
        Uri.parse('$baseUrl'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && responseData['status'] == true) {
        // log("fetched: $responseData");

        final String token = await responseData['data']['access_token'];
        final String username = await responseData['data']['user']['name'];
        // Check if the response has a 'token' key
        if (token != null) {
          // final token = responseData['data'] as String;
          print('token: $token');
          // ==== hive storage for token and pin code!!!!!
          tokenBox.put('token', token);
          pinBox.put('pin', password);

          // Store token in SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('username', username);
          // prefs.setString('access_token', token);
          // prefs.setString('pin', password);
          log("token is saved: $token");
        }

        return responseData['status'];
      } else {
        log("error: $responseData");
        final errorMessage =
            responseData['message'] as String? ?? 'Unknown error';
        throw Exception(errorMessage);
      }
    } catch (e) {
      log("error:: $e");
      throw Exception('An error occurred: $e');
    }
  }
}
