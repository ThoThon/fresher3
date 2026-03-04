import 'package:equatable/equatable.dart';

import '../../../category/entities/category.dart';
import '../../entities/product.dart';

enum ProductListStatus { initial, loading, loadingMore, success, failure }

class ProductListState extends Equatable {
  final ProductListStatus status;
  final List<Product> products;
  final List<Category> categories;
  final int? selectedCategoryId;
  final String searchQuery;
  final int currentPage;
  final bool hasReachedMax;
  final String errorMessage;
  final bool isDeleteSuccess;

  const ProductListState({
    this.status = ProductListStatus.initial,
    this.products = const [],
    this.categories = const [],
    this.selectedCategoryId,
    this.searchQuery = '',
    this.currentPage = 1,
    this.hasReachedMax = false,
    this.errorMessage = '',
    this.isDeleteSuccess = false,
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
    bool? isDeleteSuccess,
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
      isDeleteSuccess: isDeleteSuccess ?? this.isDeleteSuccess,
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
        isDeleteSuccess,
      ];
}
