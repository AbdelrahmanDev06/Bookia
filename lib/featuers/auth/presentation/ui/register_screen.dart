import 'package:bookia_app/core/routes/app_routes.dart';
import 'package:bookia_app/core/services/local_helper.dart';
import 'package:flutter/material.dart';
import '../../../../core/services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _apiService = ApiService();
  bool _isLoading = false;

  Future<void> _goHomeIfAuthenticated(Map<String, dynamic> res) async {
    final data = res['data'];
    final token = data is Map ? data['token']?.toString() : null;
    if (token == null || token.isEmpty) return;
    await LocalHelper.saveToken(token);
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.HomeScreen,
      (_) => false,
    );
  }

  void _handleRegister() async {
    setState(() => _isLoading = true);
    try {
      final res = await _apiService.register(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
      );
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['message'] ?? 'Registration Attempted')),
        );
      }
      await _goHomeIfAuthenticated(res);
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _handleRegister,
                    child: const Text('Register'),
                  ),
          ],
        ),
      ),
    );
  }
}
