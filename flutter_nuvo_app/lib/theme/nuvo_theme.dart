import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NuvoColors {
  static const Color primary = Color(0xFF2ECC71); // Verde NUVO
  static const Color secondary = Color(0xFF1ABC9C); // Aqua
  static const Color dark = Color(0xFF2C3E50); // Azul Oscuro
  static const Color background = Color(0xFFF5F6FA); // Gris muy claro
  static const Color error = Color(0xFFE74C3C); // Rojo
  static const Color white = Colors.white;
}

ThemeData nuvoTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: NuvoColors.background,
    primaryColor: NuvoColors.primary,
    
    // Esquema de colores generado desde el verde principal
    colorScheme: ColorScheme.fromSeed(
      seedColor: NuvoColors.primary,
      secondary: NuvoColors.secondary,
      surface: NuvoColors.white,
    ),

    // Tipografía
    textTheme: GoogleFonts.poppinsTextTheme(),

    // Estilo de las Tarjetas
    // CORRECCIÓN AQUÍ: Usamos 'CardThemeData' si tu versión lo pide, o 'CardTheme' si es estándar.
    // Si 'CardThemeData' no te funciona (se pone en rojo), vuelve a 'CardTheme'.
    // Basado en tu error, esta es la corrección:
    cardTheme: CardThemeData( 
      elevation: 0.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: NuvoColors.white,
      margin: const EdgeInsets.only(bottom: 12),
    ),

    // Estilo de los Botones
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: NuvoColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),

    // Estilo de los Inputs (Cajas de texto)
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: NuvoColors.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.all(20),
    ),
  );
}