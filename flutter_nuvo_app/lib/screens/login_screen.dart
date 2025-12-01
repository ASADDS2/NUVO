import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para inputFormatters
import 'package:google_fonts/google_fonts.dart';
import '../theme/nuvo_theme.dart';
import 'pin_entry_screen.dart'; // Asegúrate de tener este archivo
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();

  // CORRECCIÓN: El nombre de la función ahora coincide con la llamada del botón
  void _continue() {
    if (_phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor ingresa tu número"), backgroundColor: Colors.orange)
      );
      return;
    }

    // Navegar a la pantalla de PIN pasando el número
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => PinEntryScreen(mobileNumber: _phoneController.text)
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    // Colores Dark Mode
    const darkBgStart = Color(0xFF121418);
    const darkBgEnd = Color(0xFF0F2E26);
    const cardColor = Color(0xFF1E2228);
    const inputColor = Color(0xFF2A2E35);
    const textColor = Colors.white;
    const hintColor = Colors.white54;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [darkBgStart, darkBgEnd],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // --- TARJETA DE INGRESO ---
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      // Logo
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: NuvoColors.primary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: Text("N", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      Text("NUVO BANK", style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: textColor)),
                      Text("Banca en tu celular", style: GoogleFonts.poppins(color: hintColor, fontSize: 14)),
                      
                      const SizedBox(height: 40),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Número de Celular", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: textColor)),
                      ),
                      const SizedBox(height: 8),
                      
                      TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: GoogleFonts.poppins(fontSize: 18, color: textColor),
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Solo números
                        decoration: InputDecoration(
                          hintText: "300 123 4567",
                          hintStyle: GoogleFonts.poppins(color: hintColor),
                          prefixIcon: const Icon(Icons.phone_android_rounded, color: hintColor, size: 22),
                          fillColor: inputColor,
                          filled: true,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),

                      const SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _continue, // <--- AHORA SÍ COINCIDE
                          style: ElevatedButton.styleFrom(
                            backgroundColor: NuvoColors.primary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("CONTINUAR", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("¿No tienes una cuenta? ", style: GoogleFonts.poppins(color: hintColor, fontSize: 14)),
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const RegisterScreen())),
                      child: Text("Regístrate aquí", style: GoogleFonts.poppins(color: NuvoColors.primary, fontWeight: FontWeight.bold, fontSize: 14)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text("© 2025 NUVO BANK", style: GoogleFonts.poppins(color: hintColor, fontSize: 10)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}