import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:transport_app/main.dart';
import 'package:transport_app/models/report.dart';
import 'package:http/http.dart' as http;

class ReportService {
  static const String baseUrl =
      "https://api.horansoftware.com/api/public/api/tickets";
  Future<bool> upload(ReportModel report) async {
    await Hive.openBox<String>(tokenHive);
    final String? token = Hive.box<String>(tokenHive).get('token');
    await Hive.close();
    
    try {
      print('======= Uploading report:  ======');
      Map<String, dynamic> data = {
        "uploaded_by": report.name,
        "no_of_ticket": report.amount,
        "date": report.date,
        "plate_no": report.plate,
        "validation": "ok"
      };
      final response = await http.post(
        Uri.parse('$baseUrl'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if (responseData['status'] == true) {
        print('======= Successfull uploaded: $responseData ======');
      }
      return responseData['status'];
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }
}
