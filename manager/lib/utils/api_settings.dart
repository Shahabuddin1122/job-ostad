import 'dart:io';

import 'package:job_ostad/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiSettings {
  String endPoint;
  late final String baseUrl = baseUri;
  late final String uri = baseUrl + endPoint;

  ApiSettings({required this.endPoint});

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    return token;
  }

  Future<http.Response> postMethod(String data) async {
    try {
      String? token = await _getToken();
      final response = await http.post(
        Uri.parse(uri),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: data,
      );
      return response;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<http.Response> postMethodWithoutToken(String data) async {
    try {
      final response = await http.post(
        Uri.parse(uri),
        headers: {'Content-Type': 'application/json'},
        body: data,
      );
      return response;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<http.Response> getMethod() async {
    try {
      String? token = await _getToken();
      final response = await http.get(
        Uri.parse(uri),
        headers: {if (token != null) 'Authorization': 'Bearer $token'},
      );
      return response;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<http.Response> getMethodWithDiffEndPoint(String ep) async {
    try {
      String? token = await _getToken();
      final response = await http.get(
        Uri.parse(baseUrl + ep),
        headers: {if (token != null) 'Authorization': 'Bearer $token'},
      );
      return response;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<http.Response> putMethod(String data) async {
    try {
      String? token = await _getToken();
      final response = await http.put(
        Uri.parse(uri),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: data,
      );
      return response;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<http.StreamedResponse> postMultipartMethod({
    required Map<String, String> fields,
    File? book_image,
    File? book_pdf,
  }) async {
    try {
      String? token = await _getToken();

      var uriObj = Uri.parse(uri);
      var request = http.MultipartRequest('POST', uriObj);

      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      request.fields.addAll(fields);

      if (book_image != null) {
        request.files.add(
          await http.MultipartFile.fromPath('book_image', book_image.path),
        );
      }

      if (book_pdf != null) {
        request.files.add(
          await http.MultipartFile.fromPath('book_pdf', book_pdf.path),
        );
      }

      return await request.send();
    } catch (e) {
      throw Exception("Multipart upload failed: $e");
    }
  }
}
