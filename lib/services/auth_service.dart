import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? verificationId;

  Future<void> sendOTP(String phone) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      codeSent: (id, _) {
        verificationId = id;
      },
      verificationCompleted: (cred) async {
        await _auth.signInWithCredential(cred);
      },
      verificationFailed: (e) {
        throw Exception(e.message);
      },
      codeAutoRetrievalTimeout: (_) {},
    );
  }

  Future<void> verifyOTP(String otp) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId!,
      smsCode: otp,
    );
    await _auth.signInWithCredential(credential);
  }
}
