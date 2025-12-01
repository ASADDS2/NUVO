import 'package:flutter/material.dart';
import 'theme/nuvo_theme.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const NuvoApp());
}

class NuvoApp extends StatelessWidget {
  const NuvoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nuvo Bank',
      debugShowCheckedModeBanner: false,
      theme: nuvoTheme(),
      home: const LoginScreen(),
    );
  }
}