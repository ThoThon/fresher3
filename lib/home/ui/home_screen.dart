import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Fresher Demo 3',
          style: GoogleFonts.poppins(
              color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner chào mừng
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chào mừng bạn!',
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Dự án của bạn đã sẵn sàng với Bloc và Hive.',
                    style: GoogleFonts.poppins(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Tiêu đề danh sách
            Text(
              'Tính năng chính',
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            // Grid hiển thị tạm
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              children: [
                _buildCategoryCard(
                    'Sản phẩm', Icons.inventory_2, Colors.orange),
                _buildCategoryCard(
                    'Đơn hàng', Icons.shopping_cart, Colors.green),
                _buildCategoryCard('Khách hàng', Icons.people, Colors.purple),
                _buildCategoryCard('Cài đặt', Icons.settings, Colors.blueGrey),
              ],
            ),
          ],
        ),
      ),
      // Nút thêm mới nhanh
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildCategoryCard(String title, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(height: 10),
          Text(
            title,
            style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
