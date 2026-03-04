import 'package:equatable/equatable.dart';
import '../../entities/category.dart';

enum CategoryListStatus { initial, loading, loaded, error }

class CategoryState extends Equatable {
  final CategoryListStatus getCategoriesStatus;
  final CategoryListStatus deleteCategoryStatus;
  final List<Category> categories;
  final String errorMessage;

  const CategoryState({
    this.getCategoriesStatus = CategoryListStatus.initial,
    this.deleteCategoryStatus = CategoryListStatus.initial,
    this.categories = const [],
    this.errorMessage = '',
  });

  CategoryState copyWith({
    CategoryListStatus? getCategoriesStatus,
    CategoryListStatus? deleteCategoryStatus,
    List<Category>? categories,
    String? errorMessage,
  }) {
    return CategoryState(
      getCategoriesStatus: getCategoriesStatus ?? this.getCategoriesStatus,
      deleteCategoryStatus: deleteCategoryStatus ?? this.deleteCategoryStatus,
      categories: categories ?? this.categories,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        getCategoriesStatus,
        deleteCategoryStatus,
        categories,
        errorMessage,
      ];
}