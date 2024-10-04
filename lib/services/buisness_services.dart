import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';

const storage = FlutterSecureStorage();

// Function to fetch all businesses
Future<List<dynamic>> fetchBusinesses() async {
  final token = await storage.read(key: 'jwt_token');
  if (token == null) {
    throw Exception('No authentication token found');
  }

  final decodedToken = JwtDecoder.decode(token);
  final role = decodedToken['role'];
  if (role != 'owner') {
    throw Exception('You do not have permission to view this page');
  }

  final response = await http.get(
    Uri.parse('https://business-management-gagi.onrender.com/api/business/all'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['businesses'];
  } else {
    throw Exception('Failed to load businesses: ${response.reasonPhrase}');
  }
}

// Function to create a new business
Future<void> createBusiness(String name, String? description) async {
  final token = await storage.read(key: 'jwt_token');
  if (token == null) {
    throw Exception('No authentication token found');
  }

  final decodedToken = JwtDecoder.decode(token);
  final role = decodedToken['role'];
  if (role != 'owner') {
    throw Exception('You do not have permission to create a business');
  }

  final response = await http.post(
    Uri.parse('https://business-management-gagi.onrender.com/api/business/create'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'name': name,
      'description': description,
    }),
  );

  if (response.statusCode != 201) {
    final error = json.decode(response.body)['error'];
    throw Exception('Failed to create business: $error');
  }
}
