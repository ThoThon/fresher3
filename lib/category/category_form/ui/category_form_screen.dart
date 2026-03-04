import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/category_form_cubit.dart';
import '../cubit/category_form_state.dart';
import '../../entities/category.dart';
import '../repositories/category_form_repository.dart';

class CategoryFormScreen extends StatelessWidget {
  final Category? initialCategory;

  const CategoryFormScreen({super.key, this.initialCategory});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryFormCubit(
        CategoryFormRepository(),
        initialCategory: initialCategory,
      ),
      child: const _CategoryFormView(),
    );
  }
}

class _CategoryFormView extends StatelessWidget {
  const _CategoryFormView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<CategoryFormCubit, CategoryFormState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == CategoryStatus.success) {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.isEditMode ? "Đã cập nhật" : "Đã thêm mới"),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state.status == CategoryStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<CategoryFormCubit, CategoryFormState>(
        builder: (context, state) {
          final cubit = context.read<CategoryFormCubit>();
          final isLoading = state.status == CategoryStatus.loading;

          return Scaffold(
            appBar: AppBar(
              title: Text(state.isEditMode ? "Sửa danh mục" : "Thêm danh mục"),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0.5,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: cubit.nameController,
                    decoration: InputDecoration(
                      labelText: "Tên danh mục",
                      hintText: "Nhập tên danh mục...",
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFf24e1e),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: isLoading ? null : () => cubit.submitForm(),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            state.isEditMode ? "CẬP NHẬT" : "LƯU DANH MỤC",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
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
}