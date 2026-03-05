import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../category/category_list/repositories/category_repository.dart';
import '../../../routes/app_routes.dart';
import '../../entities/product.dart';
import '../../models/product_model.dart';
import '../bloc/product_list_bloc.dart';
import '../bloc/product_list_event.dart';
import '../bloc/product_list_state.dart';
import '../repositories/product_list_repository.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductListBloc(
        ProductListRepository(),
        CategoryRepository(),
      )..add(const ProductListFetched()),
      child: const _ProductListView(),
    );
  }
}

class _ProductListView extends StatelessWidget {
  const _ProductListView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductListBloc, ProductListState>(
      listenWhen: (prev, curr) => prev.deleteStatus != curr.deleteStatus,
      listener: (context, state) {
        if (state.deleteStatus == ProductDeleteStatus.loaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Đã xóa sản phẩm"),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text(
            "Quản lý Sản phẩm",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0.5,
        ),
        body: Stack(
          children: [
            Column(
              children: [
                _buildSearchBar(context),
                _buildCategoryFilter(),
                Expanded(child: _buildProductList()),
              ],
            ),
            BlocBuilder<ProductListBloc, ProductListState>(
              buildWhen: (prev, curr) => prev.deleteStatus != curr.deleteStatus,
              builder: (context, state) {
                if (state.deleteStatus == ProductDeleteStatus.loading) {
                  return Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(
                      child:
                          CircularProgressIndicator(color: Color(0xFFf24e1e)),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      child: TextField(
        onChanged: (query) => context
            .read<ProductListBloc>()
            .add(ProductListSearchChanged(query)),
        decoration: InputDecoration(
          hintText: "Tìm sản phẩm...",
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 60,
      child: BlocBuilder<ProductListBloc, ProductListState>(
        buildWhen: (prev, curr) =>
            prev.categories != curr.categories ||
            prev.selectedCategoryId != curr.selectedCategoryId,
        builder: (context, state) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: state.categories.length + 1,
            itemBuilder: (context, index) {
              final isAll = index == 0;
              final label = isAll ? "Tất cả" : state.categories[index - 1].name;
              final id = isAll ? null : state.categories[index - 1].id;
              final isSelected = state.selectedCategoryId == id;

              return GestureDetector(
                onTap: () => context
                    .read<ProductListBloc>()
                    .add(ProductListCategoryChanged(id)),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFf24e1e) : Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: isSelected ? Colors.transparent : Colors.grey,
                    ),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildProductList() {
    return BlocBuilder<ProductListBloc, ProductListState>(
      builder: (context, state) {
        if (state.status == ProductListStatus.loading &&
            state.products.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFf24e1e)),
          );
        }

        if (state.products.isEmpty) {
          return _buildEmptyState();
        }

        return SmartRefresher(
          controller: context.read<ProductListBloc>().refreshController,
          enablePullDown: true,
          enablePullUp: true,
          onRefresh: () =>
              context.read<ProductListBloc>().add(const ProductListRefreshed()),
          onLoading: () =>
              context.read<ProductListBloc>().add(const ProductListLoadMore()),
          header: const WaterDropHeader(waterDropColor: Color(0xFFf24e1e)),
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              return _buildProductCard(context, state.products[index]);
            },
          ),
        );
      },
    );
  }

  Widget _buildProductCard(BuildContext context, Product product) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            product.image,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 60,
              height: 60,
              color: Colors.grey[200],
              child: const Icon(Icons.image, color: Colors.grey),
            ),
          ),
        ),
        title: Text(
          product.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              "Giá: \$${product.price}",
              style: const TextStyle(
                  color: Color(0xFFf24e1e), fontWeight: FontWeight.w600),
            ),
            Text(
              "Kho: ${product.stock}",
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.blue),
              onPressed: () => _goToForm(context, product: product),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _showDeleteDialog(context, product.id),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            "Không tìm thấy sản phẩm",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Xác nhận xóa"),
        content: const Text("Bạn có chắc chắn muốn xóa sản phẩm này không?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(dialogContext);
              context
                  .read<ProductListBloc>()
                  .add(ProductListDeleteRequested(id));
            },
            child: const Text("Xóa", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _goToForm(BuildContext context, {Product? product}) async {
    final result = await Navigator.pushNamed(
      context,
      Routes.productForm,
      arguments: product as ProductModel?,
    );
    if (result == true && context.mounted) {
      context.read<ProductListBloc>().add(const ProductListRefreshed());
    }
  }
}
