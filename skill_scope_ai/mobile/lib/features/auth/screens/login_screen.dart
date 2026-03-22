import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/constants/app_constants.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) async {
    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: data.name,
        password: data.password,
      );
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> _signupUser(SignupData data) async {
    try {
      await Supabase.instance.client.auth.signUp(
        email: data.name!,
        password: data.password!,
      );
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> _recoverPassword(String name) async {
    try {
      await Supabase.instance.client.auth.resetPasswordForEmail(name);
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterLogin(
        title: AppConstants.appName,
        onLogin: _authUser,
        onSignup: _signupUser,
        
        onSubmitAnimationCompleted: () {
          // Navigation handled by GoRouter
        },
        onRecoverPassword: _recoverPassword,
        theme: LoginTheme(
          
          primaryColor: Color(0xFF0F172A),
          accentColor: Theme.of(context).colorScheme.primary,
          buttonTheme: LoginButtonTheme(
            backgroundColor: Theme.of(context).colorScheme.primary,
            splashColor: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
