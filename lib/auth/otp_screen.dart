import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../home/map_screen.dart';

class OTPScreen extends StatefulWidget {
  final AuthService authService;
  const OTPScreen({super.key, required this.authService});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final otpController = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: '6 digit OTP',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      setState(() => loading = true);
                      await widget.authService
                          .verifyOTP(otpController.text);
                      setState(() => loading = false);

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MapScreen(),
                        ),
                      );
                    },
                    child: const Text('Verify'),
                  ),
          ],
        ),
      ),
    );
  }
}
