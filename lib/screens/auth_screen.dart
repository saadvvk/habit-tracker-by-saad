import 'package:flutter/material.dart';
import '../main.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  bool loading = false;
  String? errorText;

  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  Future<void> submit() async {
    setState(() {
      loading = true;
      errorText = null;
    });
    try {
      if (isLogin) {
        await supabase.auth.signInWithPassword(
          email: emailCtrl.text.trim(),
          password: passwordCtrl.text,
        );
      } else {
        await supabase.auth.signUp(
          email: emailCtrl.text.trim(),
          password: passwordCtrl.text,
        );
      }
    } catch (e) {
      setState(() => errorText = e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4F46E5),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Icon(Icons.local_fire_department,
                      color: Colors.white, size: 44),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Habit Tracker',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B)),
                ),
                const Text(
                  'by Saad',
                  style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: passwordCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                if (errorText != null) ...[
                  const SizedBox(height: 12),
                  Text(errorText!,
                      style: const TextStyle(color: Colors.red, fontSize: 13)),
                ],
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: loading ? null : submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF4F46E5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: loading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2),
                          )
                        : Text(isLogin ? 'Log In' : 'Sign Up'),
                  ),
                ),
                const SizedBox(height: 14),
                TextButton(
                  onPressed: () => setState(() => isLogin = !isLogin),
                  child: Text(isLogin
                      ? "Don't have an account? Sign Up"
                      : 'Already have an account? Log In'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
