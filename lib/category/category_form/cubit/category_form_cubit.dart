import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../entities/category.dart';
import '../../models/category_request.dart';
import '../repositories/category_form_repository.dart';
import 'category_form_state.dart';

class CategoryFormCubit extends Cubit<CategoryFormState> {
  final CategoryFormRepository _repo;
  final Category? initialCategory;

  final nameController = TextEditingController();

  CategoryFormCubit(this._repo, {this.initialCategory}) 
      : super(const CategoryFormState()) {
    if (initialCategory != null) {
      nameController.text = initialCategory!.name;
      emit(state.copyWith(
        category: initialCategory,
        isEditMode: true,
      ));
    }
  }

  Future<void> submitForm() async {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      emit(state.copyWith(
        status: CategoryStatus.error,
        errorMessage: "Vui lòng nhập tên",
      ));
      return;
    }

    emit(state.copyWith(status: CategoryStatus.loading));

    try {
      final request = CategoryRequest(name: name);
      bool success;

      if (state.isEditMode && state.category != null) {
        success = await _repo.updateCategory(state.category!.id, request);
      } else {
        success = await _repo.createCategory(request);
      }

      if (success) {
        emit(state.copyWith(status: CategoryStatus.success));
      } else {
        emit(state.copyWith(
          status: CategoryStatus.error,
          errorMessage: "Thao tác thất bại",
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: CategoryStatus.error,
        errorMessage: "Thao tác thất bại. Vui lòng thử lại",
      ));
    }
  }

  @override
  Future<void> close() {
    nameController.dispose();
    return super.close();
  }
}