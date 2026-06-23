import 'dart:convert';
import 'package:flutter/cupertino.dart';
import '../../Data/Network/base_api_service.dart';
import '../../Data/Network/network_api_service.dart';
import '../Utils/Constants/utils.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class MethodsRepository {
  final BaseApiService _apiService = NetworkApiService();

  Future<T> getRequest<T>(String url, T Function(Map<String, dynamic>) fromJson) async {
    try {
      debugPrint("APP URL: $url");
      final response = await _apiService.getGetApiResponse(url);

      Map<String, dynamic>? data;
      if (response is Map<String, dynamic>) {
        data = response;
      } else if (response is String) {
        final decoded = jsonDecode(response);
        if (decoded is Map<String, dynamic>) data = decoded;
      }

      if (data != null) {
        // ← removed the bool success check — it was throwing for this API
        return fromJson(data);
      }
      throw Exception("Response is not valid: $response");
    } catch (e) {
      showToast(e.toString());
      debugPrint("Error fetching $url: $e");
      rethrow;
    }
  }


  Future<Map<String, dynamic>> postRequest(
      String url, {
        Map<String, dynamic>? params,
      }) async {
    try {
      debugPrint("APP URL: $url");
      debugPrint("POST Params: $params");

      final response = await _apiService.postPostApiResponse(url, params ?? {},);

      Map<String, dynamic>? data;
      if (response is Map<String, dynamic>) {
        data = response;
      } else if (response is String) {
        final decoded = jsonDecode(response);
        if (decoded is Map<String, dynamic>) data = decoded;
      }

      if (data != null) return data;
      throw Exception("Response is not valid: $response");
    } catch (e) {
      showToast(e.toString());
      debugPrint("Error posting to $url: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> postMultipart(
      String url, {
        required Map<String, String> fields,
        Map<String, File> files = const {},
      }) async {
    try {
      final uri     = Uri.parse(url);
      final request = http.MultipartRequest('POST', uri);

      // Add text fields
      request.fields.addAll(fields);

      // Add files
      for (final entry in files.entries) {
        request.files.add(
          await http.MultipartFile.fromPath(entry.key, entry.value.path),
        );
      }

      final streamed  = await request.send();
      final response  = await http.Response.fromStream(streamed);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        debugPrint('postMultipart error: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('postMultipart exception: $e');
      return null;
    }
  }

/*
  Future<dynamic> createAcceptReq(dynamic data,String id) async {
    try {
      debugPrint('Create Data: $data');
      dynamic response = await _apiService
          .postPostApiResponse("${AppEndPoints.approvals}/$id/approve", data, isAuth: false);
      return response;
    } catch (e) {
      showToast("Failed to submit approve approval request");
      debugPrint("Exception: ${e.toString()}");
      rethrow;
    }
  }
*/


}
