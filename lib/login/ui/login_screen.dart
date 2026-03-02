import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';
import 'widgets/footer_button.dart';
import 'widgets/input_field_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: const LoginScreenView(),
    );
  }
}

class LoginScreenView extends StatelessWidget {
  const LoginScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.errorMessage.isNotEmpty) {
            _showErrorDialog(context, state.errorMessage);
          }
          if (state.isLoginSuccess) {
            Navigator.of(context).pushReplacementNamed('/home');
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: SafeArea(
              child: Form(
                key: context.read<LoginBloc>().formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildIconLogo(),
                    const SizedBox(height: 24),
                    _buildUserName(context),
                    const SizedBox(height: 24),
                    _buildPassword(context),
                    const SizedBox(height: 30),
                    _buttonLogin(context, state),
                    const SizedBox(height: 200),
                    _buildBottom(),
                    SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIconLogo() {
    return Container(
      padding: const EdgeInsets.only(top: 70, left: 16),
      child: SvgPicture.asset('assets/images/logo.svg', width: 180, height: 50),
    );
  }

  Widget _buildUserName(BuildContext context) {
    return InputFieldBloc(
      label: "Tài khoản",
      controller: context.read<LoginBloc>().usernameController,
      hintText: 'Tài khoản',
      clearIconAsset: 'assets/icons/blank.svg',
      validator: (value) => (value == null || value.trim().isEmpty) ? 'Tài khoản không được để trống' : null,
    );
  }

  Widget _buildPassword(BuildContext context) {
    return InputFieldBloc(
      label: "Mật khẩu",
      controller: context.read<LoginBloc>().passwordController,
      hintText: 'Mật khẩu',
      showPassword: true,
      validator: (value) {
        if (value == null || value.trim().isEmpty) return 'Mật khẩu không được để trống';
        if (value.length < 6) return 'Mật khẩu tối thiểu 6 ký tự';
        return null;
      },
    );
  }

  Widget _buttonLogin(BuildContext context, LoginState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: state.isLoading
              ? null
              : () => context.read<LoginBloc>().add(const LoginSubmitted()),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFf24e1e),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: state.isLoading
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white))
              : const Text("Đăng nhập", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Thông báo"),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Đóng")),
        ],
      ),
    );
  }

  Widget _buildBottom() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FooterButton(svgAsset: 'assets/icons/headphone.svg', label: 'Trợ giúp', onTap: () {}),
          FooterButton(svgAsset: 'assets/icons/facebook.svg', label: 'Group', onTap: () {}),
          FooterButton(svgAsset: 'assets/icons/search.svg', label: 'Tra cứu', onTap: () {}),
        ],
      ),
    );
  }
}