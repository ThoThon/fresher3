import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

import '../navigation/app_navigator.dart';
import '../../routes/app_routes.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final box = Hive.box('settings');
    final String? token = box.get('token');

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      Hive.box('settings').delete('token');

      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        Routes.login,
        (route) => false,
      );
    }
    return handler.next(err);
  }
}
