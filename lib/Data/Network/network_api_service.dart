import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../token.dart';
import '../app_exceptions.dart';
import 'base_api_service.dart';

class NetworkApiService extends BaseApiService {
  Dio dio = Dio();
  UserToken userToken = UserToken();

  @override
  Future getGetApiResponse(String url) async {
    dynamic responseJson;
    try {
     // await userToken.loadUserToken();
      Map<String, String> headers = {
     //   'Authorization': 'Bearer ${UserToken.token}',
        'Content-Type': 'application/json'
      };
      final response = await dio.get(
        url,
        options: Options(headers: headers),

      );
      responseJson = returnResponse(response);
      debugPrint("Response JSON: $responseJson");
    } on DioException catch (e) {
      if (e.response != null) {
        responseJson = returnResponse(e.response!);
      } else {
        throw FetchDataException('No Internet Connection');
      }
    }
    return responseJson;
  }

@override
  Future getGetBodyApiResponse(String url, Map<String, dynamic>  data) async {
    dynamic responseJson;
    try {
      debugPrint('Data: $data');

  //    await userToken.loadUserToken();
      Map<String, String> headers = {
       // 'Authorization': 'Bearer ${UserToken.token}',
        'Content-Type': 'application/json'
      };
      final response = await dio.get(
        url,
        data: jsonEncode(data),
        options: Options(headers: headers),

      );
      responseJson = returnResponse(response);
      debugPrint("Response JSON: $responseJson");
    } on DioException catch (e) {
      if (e.response != null) {
        responseJson = returnResponse(e.response!);
      } else {
        throw FetchDataException('No Internet Connection');
      }
    }
    return responseJson;
  }

  @override
  Future postPostApiResponse(String url, Map data, {bool? isAuth}) async {
    debugPrint('URL: $url');
    debugPrint('Network Data: $data');
    dynamic responseJson;

    try {



      final startTime = DateTime.now();

      final response = await dio
          .post(
        url,
        data: FormData.fromMap(Map<String, dynamic>.from(data)), // ← Changed from jsonEncode to FormData
        options: Options(
          followRedirects: true,
          validateStatus: (status) => status! < 500,
        ),
      )
          .timeout(const Duration(seconds: 30));

      print("Post response:$response");
      final endTime = DateTime.now();
      final responseTime = endTime.difference(startTime).inSeconds;
      debugPrint('Response Time: $responseTime s');
      responseJson = returnResponse(response);
     // 3810444738101
      String responseString;
      if (responseJson is Map<String, dynamic>) {
        responseString = jsonEncode(responseJson);
        print("Post response:$responseString");
      } else {
        responseString = responseJson.toString();
        print("Post response:$responseString");
      }

      debugPrint(
          'Returning Raw Response JSON as String (Local): $responseString');
      return responseString;
    } on TimeoutException catch (_) {
      Fluttertoast.showToast(msg: 'Request timed out');
      throw FetchDataException('Request timed out');
    } on DioException catch (e) {
      if (e.response != null) {
        responseJson = returnResponse(e.response!);
      } else {
        Fluttertoast.showToast(msg: 'No Internet Connection');
        throw FetchDataException('No Internet Connection');
      }
    }
  }


  @override
  Future postApiWithOutBody(String url, {bool? isAuth}) async {
    debugPrint('URL: $url');
    dynamic responseJson;

    try {
      //await userToken.loadUserToken();
      Map<String, String> headers = {
   //     'Authorization': 'Bearer ${UserToken.token}',
        'Content-Type': 'application/json'
      };

      Map<String, String> headers2 = {'Content-Type': 'application/json'};

      debugPrint('Network Headers: $headers');
      debugPrint('Network Headers2: $headers2');

      final startTime = DateTime.now();

      final response = await dio
          .post(
        url,
        options: Options(headers: isAuth == true ? headers2 : headers),
      )
          .timeout(const Duration(seconds: 30));

      print("Post response:$response");
      final endTime = DateTime.now();
      final responseTime = endTime.difference(startTime).inSeconds;
      debugPrint('Response Time: $responseTime s');
      responseJson = returnResponse(response);

      String responseString;
      if (responseJson is Map<String, dynamic>) {
        responseString = jsonEncode(responseJson);
        print("Post response:$responseString");
      } else {
        responseString = responseJson.toString();
        print("Post response:$responseString");
      }

      debugPrint(
          'Returning Raw Response JSON as String (Local): $responseString');
      return responseString;
    } on TimeoutException catch (_) {
      Fluttertoast.showToast(msg: 'Request timed out');
      throw FetchDataException('Request timed out');
    } on DioException catch (e) {
      if (e.response != null) {
        responseJson = returnResponse(e.response!);
      } else {
        Fluttertoast.showToast(msg: 'No Internet Connection');
        throw FetchDataException('No Internet Connection');
      }
    }
  }



  dynamic returnResponse(dynamic response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        dynamic responseJson = response.data;
        return responseJson;
      case 204:
        dynamic responseJson = response.data;
        return responseJson;
      case 302: // Add this case
        debugPrint('⚠️ Received 302 Redirect');
        debugPrint('Redirect Location: ${response.headers['location']}');
        throw FetchDataException('Server redirected the request. Check API endpoint.');
      case 400:
        throw BadRequestException(response.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.data.toString());
      case 404:
        throw UnauthorisedException(response.data.toString());

      case 422: // Validation error
        throw BadRequestException(
            response.data['message'] ?? 'Validation failed'
        );
      case 500:
      default:
        throw FetchDataException(
            'Error occurred while communicating with server with status code : ${response.statusCode}');
    }
  }
}
