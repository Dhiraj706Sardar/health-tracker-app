import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserModel?> signInWithGoogle() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account != null) {
        final user = UserModel(
          id: account.id,
          name: account.displayName ?? '',
          email: account.email,
          photoUrl: account.photoUrl,
        );
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userId', user.id);
        await prefs.setString('userName', user.name);
        await prefs.setString('userEmail', user.email);
        await prefs.setString('userPhoto', user.photoUrl ?? '');
        
        return user;
      }
    } catch (error) {
      debugPrint('Error signing in: $error');
    }
    return null;
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    
    if (isLoggedIn) {
      return UserModel(
        id: prefs.getString('userId') ?? '',
        name: prefs.getString('userName') ?? '',
        email: prefs.getString('userEmail') ?? '',
        photoUrl: prefs.getString('userPhoto'),
      );
    }
    return null;
  }
}
