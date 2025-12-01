import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/nuvo_theme.dart';
import 'home_screen.dart';

class PinEntryScreen extends StatefulWidget {
  // CORRECCIÓN: Definimos que recibimos un 'mobileNumber'
  final String mobileNumber; 
  
  const PinEntryScreen({super.key, required this.mobileNumber});

  @override
  State<PinEntryScreen> createState() => _PinEntryScreenState();
}

class _PinEntryScreenState extends State<PinEntryScreen> {
  String _pin = "";
  bool _isLoading = false;

  // Colores oscuros del tema
  final Color _bgStart = const Color(0xFF0D1117);
  final Color _bgEnd = const Color(0xFF011812);

  void _onKeyPressed(String val) {
    if (_isLoading) return;

    if (val == 'DEL') {
      if (_pin.isNotEmpty) {
        setState(() => _pin = _pin.substring(0, _pin.length - 1));
      }
    } else {
      if (_pin.length < 4) {
        setState(() => _pin += val);
        if (_pin.length == 4) {
          _validatePin();
        }
      }
    }
  }

  void _validatePin() async {
    setState(() => _isLoading = true);
    // Simulación de validación
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() => _isLoading = false);

    // PIN de prueba (1234)
    if (_pin == "1234") { 
      _goToHome();
    } else {
      _pin = "";
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Clave incorrecta", textAlign: TextAlign.center),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(20),
          ),
        );
      }
    }
  }

  void _goToHome() async {
    final prefs = await SharedPreferences.getInstance();
    // Guardamos el nombre usando el número que recibimos
    await prefs.setString('userName', "Usuario ${widget.mobileNumber}");

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context, 
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false // Borra el historial para no volver al login
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_bgStart, _bgEnd],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Column(
                  children: [
                    Text("Escribe tu clave", style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 10),
                    // Usamos la variable widget.mobileNumber
                    Text("Para el número ${widget.mobileNumber}", style: GoogleFonts.poppins(fontSize: 16, color: Colors.white54)),
                    
                    const SizedBox(height: 40),
                    
                    // Indicadores de PIN
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (index) {
                        bool isFilled = index < _pin.length;
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          width: 50, height: 50,
                          decoration: BoxDecoration(
                            color: isFilled ? NuvoColors.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isFilled ? NuvoColors.primary : Colors.white24, width: 2),
                            boxShadow: isFilled ? [BoxShadow(color: NuvoColors.primary.withOpacity(0.4), blurRadius: 10)] : []
                          ),
                          child: isFilled ? const Icon(Icons.circle, size: 12, color: Colors.black) : null,
                        );
                      }),
                    ),
                  ],
                ),
              ),

              // Teclado numérico
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: Column(
                  children: [
                    _buildNumRow("1", "2", "3"),
                    _buildNumRow("4", "5", "6"),
                    _buildNumRow("7", "8", "9"),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 70, height: 70),
                        _NumButton(number: "0", onTap: () => _onKeyPressed("0")),
                        GestureDetector(
                          onTap: () => _onKeyPressed("DEL"),
                          child: Container(width: 70, height: 70, color: Colors.transparent, child: const Icon(Icons.backspace_outlined, color: Colors.white, size: 28)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Botón ayuda
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(color: NuvoColors.primary, borderRadius: BorderRadius.circular(30)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.help_outline, color: Colors.black, size: 20),
                      const SizedBox(width: 8),
                      Text("¿Se te olvidó?", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.black))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumRow(String n1, String n2, String n3) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NumButton(number: n1, onTap: () => _onKeyPressed(n1)),
          _NumButton(number: n2, onTap: () => _onKeyPressed(n2)),
          _NumButton(number: n3, onTap: () => _onKeyPressed(n3)),
        ],
      ),
    );
  }
}

class _NumButton extends StatelessWidget {
  final String number;
  final VoidCallback onTap;
  const _NumButton({required this.number, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70, height: 70,
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: Center(child: Text(number, style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.w500, color: Colors.white))),
      ),
    );
  }
}