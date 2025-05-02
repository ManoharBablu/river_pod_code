import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:sample_app/models/products_model.dart';
import 'package:sample_app/shared_utils/shared_utils.dart';

class ApiServices {
  Future<String> login(String username, String password) async {
    const String loginUrl = "https://apis.ccbp.in/login";
    try {
      final Uri url = Uri.parse(loginUrl);
      final headers = {'Content-Ttype': 'application/json'};
      final body = jsonEncode({'username': username, 'password': password});

      final response = await http.post(url, headers: headers, body: body);

      log('Status: ${response.statusCode}');
      log('Response: ${response.body}');

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final token = data['jwt_token'];
        SharedPreferencesUtil.saveAuthToken(token);

        if (token != null) {
          log('Login is successful. Token: $token');
          return token;
        } else {
          throw Exception('Token not found');
        }
      } else {
        throw Exception(data['error_msg'] ?? 'Login failed');
      }
    } catch (e) {
      log('Login error: $e');
      throw Exception(e.toString().replaceFirst('Exception:', ''));
    }
  }

  Future<List<Product>> fetchProducts(String token) async {
    const url = "https://apis.ccbp.in/products";

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $token',
        'Content-Ttype': 'application/json',
      });

      log('Get $url -> ${response.statusCode} ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['products'];
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['error_mmsg'] ?? "Failed to fetch products");
      }
    } catch (e) {
      log('unexpected error $e');
      return fetchProducts(token);
    }
  }
}
