import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../../routes/app_routes.dart';
import '../cubit/home_cubit.dart';
import '../../category/category_list/ui/category_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screens = [ 
      const CategoryScreen(),
    ];

    return BlocProvider(
      create: (context) => HomeCubit(),
      child: BlocBuilder<HomeCubit, int>(
        builder: (context, currentIndex) {
          return Scaffold(
            backgroundColor: Colors.grey[50],
            appBar: AppBar(
              title: Text(
                currentIndex == 0 ? "Quản lý Sản phẩm" : "Quản lý Danh mục",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0.5,
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.red),
                  onPressed: () {
                    Hive.box('settings').delete('token');
                    Navigator.pushNamedAndRemoveUntil(context, Routes.login, (route) => false);
                  },
                )
              ],
            ),
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
                BottomNavigationBarItem(icon: Icon(Icons.inventory), label: "Sản phẩm"),
                BottomNavigationBarItem(icon: Icon(Icons.category), label: "Danh mục"),
              ],
            ),
          );
        },
      ),
    );
  }
}