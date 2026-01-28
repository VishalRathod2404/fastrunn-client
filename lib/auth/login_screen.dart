import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneController = TextEditingController();
  final authService = AuthService();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FastRunn Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: '+91XXXXXXXXXX',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      setState(() => loading = true);
                      await authService.sendOTP(phoneController.text);
                      setState(() => loading = false);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              OTPScreen(authService: authService),
                        ),
                      );
                    },
                    child: const Text('Send OTP'),
                  ),
          ],
        ),
      ),
    );
  }
}
