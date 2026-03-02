import '../../core/network/api_client.dart';
import '../../core/network/base_response.dart';
import '../models/login_request.dart';

class AuthRepository {
  final ApiClient _apiClient = ApiClient();

  Future<bool> login(LoginRequest request) async {
    final response = await _apiClient.dio.post(
      '/login',
      data: request.toJson(),
    );

    final baseResponse = BaseResponse.fromJson(response.data);
    return baseResponse.data != null;
  }
}
