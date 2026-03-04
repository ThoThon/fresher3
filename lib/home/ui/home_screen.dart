import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../product/product_list/ui/product_list_screen.dart';
import '../../routes/app_routes.dart';
import '../cubit/home_cubit.dart';
import '../../category/category_list/ui/category_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screens = [
      const ProductListScreen(),
      const CategoryScreen(),
    ];

    return BlocProvider(
      create: (context) => HomeCubit(),
      child: BlocBuilder<HomeCubit, int>(
        builder: (context, currentIndex) {
          return Scaffold(
            backgroundColor: Colors.grey[50],
            body: IndexedStack(
              index: currentIndex,
              children: screens,
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: const Color(0xFFf24e1e),
              onPressed: () {
                if (currentIndex == 0) {
                  Navigator.pushNamed(context, Routes.productForm);
                } else {
                  Navigator.pushNamed(context, Routes.categoryForm);
                }
              },
              child: const Icon(Icons.add, color: Colors.white),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (index) => context.read<HomeCubit>().changeTab(index),
              selectedItemColor: const Color(0xFFf24e1e),
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.inventory), label: "Sản phẩm"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.category), label: "Danh mục"),
              ],
            ),
          );
        },
      ),
    );
  }
}
