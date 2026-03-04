import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/category_repository.dart';
import 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepository _repo;

  CategoryCubit(this._repo) : super(const CategoryState()) {
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    emit(state.copyWith(getCategoriesStatus: CategoryListStatus.loading));
    try {
      final result = await _repo.getCategories();
      emit(state.copyWith(
        getCategoriesStatus: CategoryListStatus.loaded,
        categories: result,
      ));
    } catch (e) {
      emit(state.copyWith(
        getCategoriesStatus: CategoryListStatus.error,
        errorMessage: "Không thể tải danh mục",
      ));
    }
  }

  Future<void> confirmDelete(int id) async {
    emit(state.copyWith(deleteCategoryStatus: CategoryListStatus.loading));
    try {
      final success = await _repo.deleteCategory(id);
      if (success) {
        final updatedList = state.categories.where((c) => c.id != id).toList();
        emit(state.copyWith(
          deleteCategoryStatus: CategoryListStatus.loaded,
          categories: updatedList,
        ));
      } else {
        emit(state.copyWith(
          deleteCategoryStatus: CategoryListStatus.error,
          errorMessage: "Xóa danh mục thất bại",
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        deleteCategoryStatus: CategoryListStatus.error,
        errorMessage: "Không thể xóa danh mục",
      ));
    }
  }
}