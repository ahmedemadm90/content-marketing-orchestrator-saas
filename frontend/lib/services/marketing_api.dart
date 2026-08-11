import 'dart:convert';
import 'package:http/http.dart' as http;

class MarketingApi {
  MarketingApi({http.Client? client, this.baseUrl = 'http://10.0.2.2:8000/api/v1'}) : _client = client ?? http.Client();
  final http.Client _client;
  final String baseUrl;
  String? token;
  Map<String, String> get headers => {'Accept': 'application/json', 'Content-Type': 'application/json', if (token != null) 'Authorization': 'Bearer $token'};

  Future<int> login() async {
    final response = await _client.post(Uri.parse('$baseUrl/auth/login'), headers: headers, body: jsonEncode({'email': 'owner@marketing.test', 'password': 'password'}));
    _check(response);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    token = json['token'] as String;
    return int.tryParse(((json['workspaces'] as List<dynamic>).first as Map<String, dynamic>)['id'].toString()) ?? 0;
  }

  Future<Map<String, dynamic>> fetchDashboard(int workspaceId) async {
    final response = await _client.get(Uri.parse('$baseUrl/workspaces/$workspaceId/dashboard'), headers: headers);
    _check(response);
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<void> approvePost(int workspaceId, int postId) async {
    final response = await _client.post(Uri.parse('$baseUrl/workspaces/$workspaceId/posts/$postId/approve'), headers: headers);
    _check(response);
  }

  void _check(http.Response response) { if (response.statusCode < 200 || response.statusCode >= 300) throw Exception('API error ${response.statusCode}: ${response.body}'); }
}
