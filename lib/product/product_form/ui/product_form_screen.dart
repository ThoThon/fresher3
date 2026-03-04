import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../category/category_list/repositories/category_repository.dart';
import '../../models/product_model.dart';
import '../cubit/product_form_cubit.dart';
import '../cubit/product_form_state.dart';
import '../repositories/product_form_repository.dart';

class ProductFormScreen extends StatelessWidget {
  final ProductModel? initialProduct;

  const ProductFormScreen({super.key, this.initialProduct});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductFormCubit(
        ProductFormRepository(),
        CategoryRepository(),
        initialProduct: initialProduct,
      ),
      child: const _ProductFormView(),
    );
  }
}

class _ProductFormView extends StatelessWidget {
  const _ProductFormView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductFormCubit, ProductFormState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == ProductFormStatus.success) {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.isEditMode
                  ? "Đã cập nhật sản phẩm"
                  : "Đã thêm sản phẩm mới"),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state.status == ProductFormStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<ProductFormCubit, ProductFormState>(
        builder: (context, state) {
          final cubit = context.read<ProductFormCubit>();
          final isLoading = state.status == ProductFormStatus.loading;

          return Scaffold(
            appBar: AppBar(
              title: Text(state.isEditMode ? "Sửa sản phẩm" : "Thêm sản phẩm"),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0.5,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Form(
              key: cubit.formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildTextField(
                    cubit.nameController,
                    "Tên sản phẩm *",
                    (v) =>
                        (v == null || v.isEmpty) ? "Vui lòng nhập tên" : null,
                  ),
                  _buildTextField(
                    cubit.codeController,
                    "Mã SKU *",
                    (v) => (v == null || v.isEmpty) ? "Vui lòng nhập mã" : null,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          cubit.priceController,
                          "Giá *",
                          (v) => (double.tryParse(v ?? '') ?? 0) <= 0
                              ? "Giá phải > 0"
                              : null,
                          isNumber: true,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          cubit.stockController,
                          "Tồn kho *",
                          (v) => (int.tryParse(v ?? '') ?? -1) < 0
                              ? "Tồn kho >= 0"
                              : null,
                          isNumber: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text("Danh mục",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    value: state.categories
                            .any((c) => c.id == state.selectedCategoryId)
                        ? state.selectedCategoryId
                        : null,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: state.categories
                        .map((cat) => DropdownMenuItem(
                            value: cat.id, child: Text(cat.name)))
                        .toList(),
                    onChanged: (val) => cubit.selectCategory(val),
                    hint: const Text("Chọn danh mục"),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    cubit.descController,
                    "Mô tả",
                    null,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFf24e1e),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: isLoading ? null : () => cubit.submitForm(),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2),
                          )
                        : Text(
                            state.isEditMode ? "CẬP NHẬT" : "LƯU SẢN PHẨM",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String? Function(String?)? validator, {
    bool isNumber = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            validator: validator,
            maxLines: maxLines,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
