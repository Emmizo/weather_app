import 'package:http/http.dart' as http;

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  final http.Client _client = http.Client();

  Future<http.Response> get(String url) async {
    return await _client.get(Uri.parse(url));
  }

  void dispose() {
    _client.close();
  }
}
