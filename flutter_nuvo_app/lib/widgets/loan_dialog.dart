import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';

class LoanDialog extends StatefulWidget {
  const LoanDialog({super.key});

  @override
  State<LoanDialog> createState() => _LoanDialogState();
}

class _LoanDialogState extends State<LoanDialog> {
  final _amountCtrl = TextEditingController();
  int _selectedMonths = 12; // Valor inicial
  bool _isLoading = false;
  final ApiService _api = ApiService();

  // Colores extraídos de tu diseño
  final Color _cardColor = const Color(0xFF101214);
  final Color _inputColor = const Color(0xFF0A0C0D);
  final Color _purpleColor = const Color(0xFF5856D6); // Morado vibrante

  void _requestLoan() async {
    if (_amountCtrl.text.isEmpty) return;
    
    final amount = double.tryParse(_amountCtrl.text);
    if (amount == null || amount <= 0) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Monto inválido"), backgroundColor: Colors.red));
       return;
    }

    setState(() => _isLoading = true);

    // Simular proceso con backend
    await Future.delayed(const Duration(seconds: 2));
    
    // Llamada real si estuviera conectado:
    // await _api.requestLoan(amount, _selectedMonths);

    setState(() => _isLoading = false);

    if (mounted) {
      Navigator.pop(context, true); // Cierra y devuelve éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("¡Solicitud Enviada!"), backgroundColor: Color(0xFF5856D6))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
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
            // HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Solicitar Préstamo", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.close, size: 18, color: Colors.white),
                  ),
                )
              ],
            ),
            
            const SizedBox(height: 30),

            // INPUT MONTO
            Text("Monto Solicitado", style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 8),
            TextField(
              controller: _amountCtrl,
              keyboardType: TextInputType.number,
              style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: _inputColor,
                prefixIcon: const Icon(Icons.attach_money, color: Colors.white),
                suffixIcon: const Icon(Icons.unfold_more, color: Colors.grey),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                hintText: "0.00",
                hintStyle: TextStyle(color: Colors.grey.shade700),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),

            const SizedBox(height: 20),

            // DROPDOWN PLAZO
            Text("Plazo (Meses)", style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: _inputColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: _selectedMonths,
                  dropdownColor: _cardColor,
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                  isExpanded: true,
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
                  items: [6, 12, 18, 24, 36, 48, 60]
                      .map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text("$value Meses"),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedMonths = newValue!;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            // INFO TASA (Caja informativa)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _inputColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Tasa de Interés Aproximada", style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text("8.5% Anual", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: _purpleColor)),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // BOTÓN ACCIÓN
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _requestLoan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _purpleColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text("SOLICITAR PRÉSTAMO", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}