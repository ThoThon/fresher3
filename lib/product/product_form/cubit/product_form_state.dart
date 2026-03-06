import 'package:equatable/equatable.dart';

import '../../../category/entities/category.dart';
import '../../models/product_model.dart';

enum ProductFormStatus { initial, loading, success, error }

class ProductFormState extends Equatable {
  final ProductFormStatus status;
  final ProductModel? product;
  final bool isEditMode;
  final List<Category> categories;
  final int? selectedCategoryId;
  final String errorMessage;

  const ProductFormState({
    this.status = ProductFormStatus.initial,
    this.product,
    this.isEditMode = false,
    this.categories = const [],
    this.selectedCategoryId,
    this.errorMessage = '',
  });

  ProductFormState copyWith({
    ProductFormStatus? status,
    ProductModel? product,
    bool? isEditMode,
    List<Category>? categories,
    int? selectedCategoryId,
    bool clearCategoryId = false,
    String? errorMessage,
  }) {
    return ProductFormState(
      status: status ?? this.status,
      product: product ?? this.product,
      isEditMode: isEditMode ?? this.isEditMode,
      categories: categories ?? this.categories,
      selectedCategoryId: clearCategoryId
          ? null
          : (selectedCategoryId ?? this.selectedCategoryId),
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        product,
        isEditMode,
        categories,
        selectedCategoryId,
        errorMessage
      ];
}
