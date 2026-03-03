import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../routes/app_routes.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Quản lý Sản phẩm",
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
      body: const Center(child: Text("Danh sách sản phẩm")),
    );
  }
}
