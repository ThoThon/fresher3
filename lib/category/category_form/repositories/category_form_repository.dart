import '../../../core/network/api_client.dart';
import '../../../core/network/base_response.dart';
import '../../models/category_request.dart';

class CategoryFormRepository {
  final ApiClient _apiClient = ApiClient();

  Future<bool> createCategory(CategoryRequest data) async {
    final response = await _apiClient.dio.post(
      '/categories',
      data: data.toJson(),
    );
    final baseResponse = BaseResponse.fromJson(response.data);

    return baseResponse.data ?? false;
  }

  Future<bool> updateCategory(int id, CategoryRequest data) async {
    final response = await _apiClient.dio.put(
      '/categories/$id',
      data: data.toJson(),
    );
    final baseResponse = BaseResponse<bool>.fromJson(
      response.data,
      func: (x) => x as bool,
    );
    return baseResponse.data ?? false;
  }
}
