

abstract class BaseApiService {
  final String baseUrl = "";
  Future<dynamic> getGetApiResponse(String url);
  Future<dynamic> getGetBodyApiResponse(String url, Map<String, dynamic> data); // Changed Map to Map<String, dynamic>
  Future<dynamic> postPostApiResponse(String url, Map data,{bool? isAuth});
  Future<dynamic> postApiWithOutBody(String url,{bool? isAuth});

}