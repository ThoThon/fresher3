import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../../../routes/app_routes.dart';
import '../cubit/category_cubit.dart';
import '../cubit/category_state.dart';
import '../repositories/category_repository.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryCubit(CategoryRepository()),
      child: const _CategoryView(),
    );
  }
}

class _CategoryView extends StatelessWidget {
  const _CategoryView();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CategoryCubit, CategoryState>(
          listenWhen: (p, c) => p.getCategoriesStatus != c.getCategoriesStatus,
          listener: (context, state) {
            if (state.getCategoriesStatus == CategoryListStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(state.errorMessage),
                    backgroundColor: Colors.red),
              );
            }
          },
        ),
        BlocListener<CategoryCubit, CategoryState>(
          listenWhen: (p, c) =>
              p.deleteCategoryStatus != c.deleteCategoryStatus,
          listener: (context, state) {
            if (state.deleteCategoryStatus == CategoryListStatus.loaded) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("Đã xóa danh mục"),
                    backgroundColor: Colors.green),
              );
            } else if (state.deleteCategoryStatus == CategoryListStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(state.errorMessage),
                    backgroundColor: Colors.red),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Quản lý Danh mục",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0.5,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.red),
              onPressed: () {
                Hive.box('settings').delete('token');
                Navigator.pushNamedAndRemoveUntil(
                    context, Routes.login, (route) => false);
              },
            ),
          ],
        ),
        body: BlocBuilder<CategoryCubit, CategoryState>(
          builder: (context, state) {
            if (state.getCategoriesStatus == CategoryListStatus.loading &&
                state.categories.isEmpty) {
              return const Center(
                  child: CircularProgressIndicator(color: Color(0xFFf24e1e)));
            }

            if (state.categories.isEmpty) {
              return const Center(child: Text("Chưa có danh mục nào"));
            }

            return RefreshIndicator(
              onRefresh: () => context.read<CategoryCubit>().fetchCategories(),
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: state.categories.length,
                itemBuilder: (context, index) {
                  final cat = state.categories[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: const CircleAvatar(
                          backgroundColor: Color(0xFFf24e1e), radius: 6),
                      title: Text(cat.name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () async {
                              final result = await Navigator.pushNamed(
                                context,
                                Routes.categoryForm,
                                arguments: cat,
                              );
                              if (result == true) {
                                context.read<CategoryCubit>().fetchCategories();
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _showDeleteDialog(context, cat.id),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Xác nhận xóa"),
        content: const Text("Bạn có chắc chắn muốn xóa danh mục này?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Hủy")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<CategoryCubit>().confirmDelete(id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Xóa", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
