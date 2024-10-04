// employee_service.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EmployeeService {
  final storage = const FlutterSecureStorage();

  Future<void> addEmployee(String businessId, String email) async {
    final token = await storage.read(key: 'jwt_token');
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await http.post(
      Uri.parse('https://business-management-gagi.onrender.com/api/business/invite'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'businessId': businessId,
        'email': email,
      }),
    );

    if (response.statusCode != 200) {
      final responseData = json.decode(response.body);
      throw Exception(responseData['error']);
    }
  }
}
