import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static Future<User> signInAnonymously() async {
    final cred = await FirebaseAuth.instance.signInAnonymously();
    return cred.user!;
  }
}
