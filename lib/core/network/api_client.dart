import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:the_queue_mobile/app/auth_controller.dart';

class ApiResult {
  const ApiResult({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
  });

  final bool success;
  final int statusCode;
  final String message;
  final Map<String, dynamic>? data;
}

class ApiClient {
  ApiClient._();

  static final ApiClient instance = ApiClient._();

  static const String _baseUrl = String.fromEnvironment('API_BASE_URL');

  Future<ApiResult> invoke({
    required String endpoint,
    String method = 'POST',
    Map<String, dynamic>? body,
  }) async {
    final normalizedEndpoint = endpoint.startsWith('/')
        ? endpoint
        : '/$endpoint';

    if (_baseUrl.isEmpty) {
      await Future<void>.delayed(const Duration(milliseconds: 250));
      return _mockResponse(endpoint: normalizedEndpoint, body: body);
    }

    final uri = Uri.tryParse('$_baseUrl$normalizedEndpoint');
    if (uri == null) {
      return const ApiResult(
        success: false,
        statusCode: 0,
        message: 'Invalid API URL. Check API_BASE_URL.',
      );
    }

    try {
      final headers = <String, String>{'Content-Type': 'application/json'};
      final token = AuthController.token;
      if ((token ?? '').isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
      late final http.Response response;

      switch (method.toUpperCase()) {
        case 'GET':
          response = await http
              .get(uri, headers: headers)
              .timeout(const Duration(seconds: 20));
          break;
        case 'PATCH':
          response = await http
              .patch(
                uri,
                headers: headers,
                body: jsonEncode(body ?? <String, dynamic>{}),
              )
              .timeout(const Duration(seconds: 20));
          break;
        case 'PUT':
          response = await http
              .put(
                uri,
                headers: headers,
                body: jsonEncode(body ?? <String, dynamic>{}),
              )
              .timeout(const Duration(seconds: 20));
          break;
        case 'DELETE':
          response = await http
              .delete(
                uri,
                headers: headers,
                body: jsonEncode(body ?? <String, dynamic>{}),
              )
              .timeout(const Duration(seconds: 20));
          break;
        case 'POST':
        default:
          response = await http
              .post(
                uri,
                headers: headers,
                body: jsonEncode(body ?? <String, dynamic>{}),
              )
              .timeout(const Duration(seconds: 20));
          break;
      }

      Map<String, dynamic>? decoded;
      if (response.body.isNotEmpty) {
        final parsed = jsonDecode(response.body);
        if (parsed is Map<String, dynamic>) {
          decoded = parsed;
        }
      }

      final ok = response.statusCode >= 200 && response.statusCode < 300;
      return ApiResult(
        success: ok,
        statusCode: response.statusCode,
        message: ok
            ? (decoded?['message']?.toString() ?? 'Request successful')
            : (decoded?['message']?.toString() ??
                  'Request failed (${response.statusCode})'),
        data: decoded,
      );
    } catch (error) {
      return _mockResponse(
        endpoint: normalizedEndpoint,
        body: body,
        message: 'Offline mode active: $error',
      );
    }
  }

  ApiResult _mockResponse({
    required String endpoint,
    Map<String, dynamic>? body,
    String message = 'Mock mode success',
  }) {
    if (endpoint.startsWith('/api/v1/auth/')) {
      final identifier = (body?['identifier']?.toString() ?? '').toLowerCase();
      final role = identifier.contains('admin')
          ? 'admin'
          : identifier.contains('staff')
          ? 'staff'
          : 'customer';
      final userName =
          body?['fullName']?.toString() ??
          body?['identifier']?.toString() ??
          'QueueFlow User';

      return ApiResult(
        success: true,
        statusCode: 200,
        message: message,
        data: {
          'token': 'offline-token-${DateTime.now().millisecondsSinceEpoch}',
          'role': role,
          'user': {'name': userName},
        },
      );
    }

    return ApiResult(
      success: true,
      statusCode: 200,
      message: message,
      data: const {'offline': true},
    );
  }
}
