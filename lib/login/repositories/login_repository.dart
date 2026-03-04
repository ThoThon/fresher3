import '../../core/network/api_client.dart';
import '../../core/network/base_response.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';

class AuthRepository {
  final ApiClient _apiClient = ApiClient();

  Future<String?> login(LoginRequest request) async {
    final response = await _apiClient.dio.post(
      '/login',
      data: request.toJson(),
    );

    final baseResponse = BaseResponse<LoginResponse>.fromJson(
      response.data,
      func: (x) => LoginResponse.fromJson(x as Map<String, dynamic>),
    );
    return baseResponse.data?.accessToken;
  }
}
