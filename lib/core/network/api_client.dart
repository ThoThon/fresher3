import 'package:dio/dio.dart';
import 'api_interceptor.dart';

class ApiClient {
  late Dio dio;

  ApiClient() {
    dio = Dio(BaseOptions(
      baseUrl: "http://192.168.1.34:8080/api/v1",
    ));

    dio.interceptors.add(ApiInterceptor());
  }
}
