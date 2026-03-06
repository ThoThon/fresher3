import '../../../core/network/api_client.dart';
import '../../../core/network/base_response_list.dart';
import '../../../core/network/base_response.dart';
import '../../models/product_model.dart';

class ProductListRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<ProductModel>> getProducts({
    int page = 1,
    int limit = 10,
    String keyword = '',
    int? categoryId,
  }) async {
    final response = await _apiClient.dio.get(
      '/products',
      queryParameters: {
        'page': page,
        'limit': limit,
        'keyword': keyword,
        if (categoryId != null) 'category_id': categoryId,
      },
    );

    final baseResponse = BaseResponseList<ProductModel>.fromJson(
      response.data,
      func: (item) => ProductModel.fromJson(item),
    );

    return baseResponse.data;
  }

  Future<bool> deleteProduct(int id) async {
    final response = await _apiClient.dio.delete('/products/$id');

    final baseResponse = BaseResponse<bool>.fromJson(
      response.data,
      func: (x) => x as bool,
    );

    return baseResponse.data ?? false;
  }
}