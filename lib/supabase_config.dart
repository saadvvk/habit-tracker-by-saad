// Supabase project credentials.
// The anon/publishable key is safe to ship in the app — it only works
// through the Row Level Security policies you set up on the habits table.
class SupabaseConfig {
  static const String url = 'https://rgqmbphwvkfrhfzienbr.supabase.co';
  static const String anonKey =
      'sb_publishable_QYLEUmtl991vPIfbydYkhw_6TTMLnzA';
}


======================================================================
FILE PATH (use as filename on GitHub): lib/main.dart
======================================================================
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_config.dart';
import 'screens/auth_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  runApp(const HabitTrackerApp());
}

final supabase = Supabase.instance.client;

class HabitTrackerApp extends StatelessWidget {
  const HabitTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker by Saad',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF4F46E5), // indigo-600
        scaffoldBackgroundColor: const Color(0xFFF1F5F9), // slate-100
      ),
      home: const AuthGate(),
    );
  }
}
