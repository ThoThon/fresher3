import '../../core/network/api_client.dart';
import '../../core/network/base_response.dart';
import '../models/login_request.dart';

class AuthRepository {
  final ApiClient _apiClient = ApiClient();

  Future<String?> login(LoginRequest request) async {
    final response = await _apiClient.dio.post(
      '/login',
      data: request.toJson(),
    );

    final baseResponse = BaseResponse<Map<String, dynamic>>.fromJson(
      response.data,
      func: (x) => x as Map<String, dynamic>,
    );
    return baseResponse.data?['access_token'] as String?;
  }
}
