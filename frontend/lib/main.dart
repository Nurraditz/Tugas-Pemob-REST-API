import 'package:flutter/material.dart';
import 'screens/umkm_list_screen.dart';

void main() {
  runApp(const MyApp());
}

/// Root widget aplikasi UMKM.
/// Menggunakan Material Design 3 (Material You) sebagai improvement desain.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UMKM App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Material Design 3 dengan color scheme seed
        colorSchemeSeed: const Color(0xFF1565C0), // Biru tua
        useMaterial3: true,
        brightness: Brightness.light,

        // AppBar styling
        appBarTheme: const AppBarTheme(
          surfaceTintColor: Colors.transparent,
        ),

        // Card styling
        cardTheme: CardThemeData(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      home: const UmkmListScreen(),
    );
  }
}
