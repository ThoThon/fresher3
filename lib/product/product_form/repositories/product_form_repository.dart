import '../../../core/network/api_client.dart';
import '../../../core/network/base_response.dart';
import '../../models/product_request.dart';

class ProductFormRepository {
  final ApiClient _apiClient = ApiClient();

  Future<bool> createProduct(ProductRequest data) async {
    final response = await _apiClient.dio.post(
      '/products',
      data: data.toJson(),
    );

    final baseResponse = BaseResponse.fromJson(response.data);

    return baseResponse.data ?? false;
  }

  Future<bool> updateProduct(int id, ProductRequest data) async {
    final response = await _apiClient.dio.put(
      '/products/$id',
      data: data.toJson(),
    );

    final baseResponse = BaseResponse<bool>.fromJson(
      response.data,
      func: (x) => x as bool,
    );

    return baseResponse.data ?? false;
  }
}
