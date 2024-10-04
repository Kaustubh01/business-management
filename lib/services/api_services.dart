// api_service.dart
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

// API Base URL
const String baseUrl = 'https://business-management-gagi.onrender.com/api';

// Storage for saving and reading secure data like tokens
const storage = FlutterSecureStorage();

// Fetch JWT Token
Future<String?> _getToken() async {
  return await storage.read(key: 'jwt_token');
}

// Decode Token to get User ID
Future<String?> getUserId() async {
  final token = await _getToken();
  if (token == null) {
    return null;
  }
  final decodedToken = JwtDecoder.decode(token);
  return decodedToken['id'];
}

// Login function
Future<Map<String, dynamic>> login(String email, String password) async {
  final response = await http.post(
    Uri.parse('$baseUrl/auth/login'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'email': email, 'password': password}),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    await storage.write(key: 'jwt_token', value: data['token']);
    return data;
  } else {
    throw Exception(json.decode(response.body)['error']);
  }
}

// Register function
Future<Map<String, dynamic>> signup(String name, String email, String password, String phone, String role) async {
  final response = await http.post(
    Uri.parse('$baseUrl/auth/register'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'role': role,
    }),
  );

  if (response.statusCode == 201) {
    final data = json.decode(response.body);
    await storage.write(key: 'jwt_token', value: data['token']);
    return data;
  } else {
    final error = json.decode(response.body)['error'];
    throw Exception(error);
  }
}

// Fetch all businesses for employees
Future<List<Map<String, dynamic>>> fetchEmployeeBusinesses() async {
  final token = await _getToken();
  if (token == null) {
    throw Exception('No token found');
  }

  final response = await http.post(
    Uri.parse('$baseUrl/business/employees/buisness'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return List<Map<String, dynamic>>.from(data['businesses'] ?? []);
  } else {
    throw Exception('Failed to load businesses');
  }
}

// Fetch pending requests for employees
Future<List<Map<String, dynamic>>> fetchPendingRequests() async {
  final token = await _getToken();
  if (token == null) {
    throw Exception('No token found');
  }

  final response = await http.post(
    Uri.parse('$baseUrl/auth/pending'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final userList = data['user'] as List<dynamic>;
    return userList.map((item) {
      return {
        'businessName': item['businessName'] ?? 'No Business Name',
        'businessId': item['businessId'] ?? '',
        'userId': item['_id'] ?? '',
      };
    }).toList();
  } else {
    throw Exception('Failed to load pending requests');
  }
}

// Accept request
Future<void> acceptRequest(String businessId) async {
  final token = await _getToken();
  if (token == null) {
    throw Exception('No token found');
  }

  final response = await http.post(
    Uri.parse('$baseUrl/business/accept'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({'businessId': businessId}),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to accept request');
  }
}

// Reject request
Future<void> rejectRequest(String businessId) async {
  final token = await _getToken();
  if (token == null) {
    throw Exception('No token found');
  }

  final response = await http.post(
    Uri.parse('$baseUrl/business/reject'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({'businessId': businessId}),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to reject request');
  }
}

// Logout function
Future<void> logout() async {
  await storage.delete(key: 'jwt_token');
}
