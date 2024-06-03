import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myapp/shared/interface/abstract.service.dart';

class HttpService implements AbstractService {
  final String baseUrl;

  HttpService({required this.baseUrl});

  @override
  Future<List<Map<String, dynamic>>> get(
    String endpoint, {
    Map<String, dynamic>? params,
  }) async {
    final response = await http.get(Uri.parse(baseUrl + endpoint));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? params,
    required String body,
  }) async {
    final response = await http.post(
      Uri.parse(baseUrl + endpoint),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to post data');
    }
  }

  @override
  Future<Map<String, dynamic>> patch(
    String endpoint, {
    Map<String, dynamic>? params,
    required String body,
  }) async {
    final response = await http.patch(
      Uri.parse(baseUrl + endpoint),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        ...params ?? {},
      },
      body: body,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to patch data');
    }
  }

  @override
  Future delete(
    String endpoint, {
    Map<String, dynamic>? params,
  }) async {
    final response = await http.delete(
      Uri.parse(baseUrl + endpoint),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        ...params ?? {},
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to delete data');
    }
  }

  // Implement other HTTP methods (put, delete, etc.) as needed
}
