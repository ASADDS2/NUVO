import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import '../theme/nuvo_theme.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final _destinatarioCtrl = TextEditingController();
  final _montoCtrl = TextEditingController();
  final _conceptoCtrl = TextEditingController();
  final _pinCtrl = TextEditingController();

  final ApiService _api = ApiService();
  bool _isLoading = false;

  // Colores del Diseño
  final Color _cardColor = const Color(0xFF151718);
  final Color _inputColor = const Color(0xFF0A0C0D);
  final Color _accentColor = const Color(0xFF00C569);

  void _startTransfer() {
    if (_destinatarioCtrl.text.isEmpty || _montoCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Faltan datos obligatorios"), backgroundColor: Colors.orange)
      );
      return;
    }
    // Abrir el diálogo de PIN
    _showPinDialog();
  }

  void _processTransfer() async {
    // Validar PIN (Simulado 1234)
    if (_pinCtrl.text != "1234") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("PIN Incorrecto"), backgroundColor: Colors.red));
      _pinCtrl.clear();
      return;
    }

    setState(() => _isLoading = true);
    Navigator.pop(context); // Cerrar diálogo de PIN

    // Llamada al API
    final amount = double.parse(_montoCtrl.text);
    final targetId = int.tryParse(_destinatarioCtrl.text) ?? 0; // Asumiendo que ingresan ID numérico por ahora
    
    final success = await _api.transfer(targetId, amount);

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        // Mostrar éxito y salir
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (c) => _buildSuccessDialog(c),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error en la transferencia"), backgroundColor: Colors.red));
      }
    }
  }

  void _showPinDialog() {
    _pinCtrl.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Confirmar con PIN", textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Ingresa tu clave de 4 dígitos", style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 20),
            TextField(
              controller: _pinCtrl,
              autofocus: true,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 4,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 8),
              decoration: InputDecoration(
                counterText: "",
                filled: true,
                fillColor: _inputColor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                hintText: "••••",
                hintStyle: TextStyle(color: Colors.grey.shade700),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar", style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            onPressed: _processTransfer,
            style: ElevatedButton.styleFrom(backgroundColor: _accentColor),
            child: const Text("CONFIRMAR", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  Widget _buildSuccessDialog(BuildContext c) {
    return AlertDialog(
      backgroundColor: _cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, color: _accentColor, size: 60),
          const SizedBox(height: 20),
          Text("¡Envío Exitoso!", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 10),
          Text("Has enviado \$${_montoCtrl.text} a ${_destinatarioCtrl.text}", textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Colors.grey)),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(c); // Cerrar diálogo
                Navigator.pop(context); // Cerrar pantalla de transferencia
              },
              style: ElevatedButton.styleFrom(backgroundColor: _inputColor),
              child: const Text("LISTO", style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fondo base
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _cardColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TÍTULO
                Text("Enviar Dinero", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 30),

                // INPUT DESTINATARIO
                _buildLabel("Destinatario"),
                _buildInput(_destinatarioCtrl, "Nombre o ID de usuario", Icons.person_outline),
                
                const SizedBox(height: 20),

                // INPUT MONTO
                _buildLabel("Monto"),
                _buildInput(_montoCtrl, "0.00", Icons.attach_money, isNumber: true),

                const SizedBox(height: 20),

                // INPUT CONCEPTO
                _buildLabel("Concepto (Opcional)"),
                _buildInput(_conceptoCtrl, "¿Por qué envías este dinero?", Icons.chat_bubble_outline),

                const SizedBox(height: 40),

                // BOTÓN
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _startTransfer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _accentColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: _isLoading 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text("ENVIAR DINERO", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(text, style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14)),
    );
  }

  Widget _buildInput(TextEditingController controller, String hint, IconData icon, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
      decoration: InputDecoration(
        filled: true,
        fillColor: _inputColor,
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: Colors.grey.shade700),
        prefixIcon: Icon(icon, color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }
}