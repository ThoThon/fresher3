import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../category/category_list/repositories/category_repository.dart';
import '../../models/product_model.dart';
import '../../models/product_request.dart';
import '../repositories/product_form_repository.dart';
import 'product_form_state.dart';

class ProductFormCubit extends Cubit<ProductFormState> {
  final ProductFormRepository _repo;
  final CategoryRepository _categoryRepo;
  final ProductModel? initialProduct;

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final codeController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();
  final descController = TextEditingController();

  ProductFormCubit(this._repo, this._categoryRepo, {this.initialProduct})
      : super(const ProductFormState()) {
    if (initialProduct != null) {
      _prepareForm(initialProduct!);
      emit(state.copyWith(
        product: initialProduct,
        isEditMode: true,
        selectedCategoryId: initialProduct!.category?.id,
      ));
    }
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final result = await _categoryRepo.getCategories();
      if (!isClosed) emit(state.copyWith(categories: result));
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(
          status: ProductFormStatus.error,
          errorMessage: 'Không thể tải danh sách danh mục',
        ));
      }
    }
  }

  void _prepareForm(ProductModel product) {
    nameController.text = product.name;
    codeController.text = product.code;
    priceController.text = product.price.toString();
    stockController.text = product.stock.toString();
    descController.text = product.description;
  }

  void selectCategory(int? id) {
    if (id == null) {
      emit(state.copyWith(clearCategoryId: true));
    } else {
      emit(state.copyWith(selectedCategoryId: id));
    }
  }

  ProductRequest _getFormData() {
    return ProductRequest(
      name: nameController.text.trim(),
      code: codeController.text.trim(),
      price: double.tryParse(priceController.text) ?? 0.0,
      stock: int.tryParse(stockController.text) ?? 0,
      description: descController.text.trim(),
      categoryId: state.selectedCategoryId,
    );
  }

  Future<void> submitForm() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    emit(state.copyWith(status: ProductFormStatus.loading));

    try {
      bool success;
      final product = initialProduct;

      if (state.isEditMode && product != null) {
        success = await _repo.updateProduct(product.id, _getFormData());
      } else {
        success = await _repo.createProduct(_getFormData());
      }

      if (success) {
        emit(state.copyWith(status: ProductFormStatus.success));
      } else {
        emit(state.copyWith(
          status: ProductFormStatus.error,
          errorMessage: 'Thao tác thất bại',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: ProductFormStatus.error,
        errorMessage: 'Thao tác thất bại. Vui lòng thử lại',
      ));
    }
  }

  @override
  Future<void> close() {
    nameController.dispose();
    codeController.dispose();
    priceController.dispose();
    stockController.dispose();
    descController.dispose();
    return super.close();
  }
}
