import 'package:equatable/equatable.dart';

import '../../../category/entities/category.dart';
import '../../entities/product.dart';

enum ProductListStatus { initial, loading, loadingMore, success, failure }

enum ProductDeleteStatus { initial, loading, loaded }

class ProductListState extends Equatable {
  final ProductListStatus status;
  final List<Product> products;
  final List<Category> categories;
  final int? selectedCategoryId;
  final String searchQuery;
  final int currentPage;
  final bool hasReachedMax;
  final String errorMessage;
  final ProductDeleteStatus deleteStatus;

  const ProductListState({
    this.status = ProductListStatus.initial,
    this.products = const [],
    this.categories = const [],
    this.selectedCategoryId,
    this.searchQuery = '',
    this.currentPage = 1,
    this.hasReachedMax = false,
    this.errorMessage = '',
    this.deleteStatus = ProductDeleteStatus.initial,
  });

  ProductListState copyWith({
    ProductListStatus? status,
    List<Product>? products,
    List<Category>? categories,
    int? selectedCategoryId,
    bool clearCategoryId = false,
    String? searchQuery,
    int? currentPage,
    bool? hasReachedMax,
    String? errorMessage,
    ProductDeleteStatus? deleteStatus,
  }) {
    return ProductListState(
      status: status ?? this.status,
      products: products ?? this.products,
      categories: categories ?? this.categories,
      selectedCategoryId: clearCategoryId
          ? null
          : (selectedCategoryId ?? this.selectedCategoryId),
      searchQuery: searchQuery ?? this.searchQuery,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
      deleteStatus: deleteStatus ?? this.deleteStatus,
    );
  }

  @override
  List<Object?> get props => [
        status,
        products,
        categories,
        selectedCategoryId,
        searchQuery,
        currentPage,
        hasReachedMax,
        errorMessage,
        deleteStatus,
      ];
}
