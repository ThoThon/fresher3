import 'package:equatable/equatable.dart';

import '../../entities/category.dart';

enum CategoryStatus { initial, loading, success, error }

class CategoryFormState extends Equatable {
  final CategoryStatus status;
  final Category? category;
  final String errorMessage;
  final bool isEditMode;

  const CategoryFormState({
    this.status = CategoryStatus.initial,
    this.category,
    this.errorMessage = '',
    this.isEditMode = false,
  });

  CategoryFormState copyWith({
    CategoryStatus? status,
    Category? category,
    String? errorMessage,
    bool? isEditMode,
  }) {
    return CategoryFormState(
      status: status ?? this.status,
      category: category ?? this.category,
      errorMessage: errorMessage ?? this.errorMessage,
      isEditMode: isEditMode ?? this.isEditMode,
    );
  }

  @override
  List<Object?> get props => [status, category, errorMessage, isEditMode];
}