import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';

class RechargeDialog extends StatefulWidget {
  const RechargeDialog({super.key});

  @override
  State<RechargeDialog> createState() => _RechargeDialogState();
}

class _RechargeDialogState extends State<RechargeDialog> {
  final _amountCtrl = TextEditingController();
  String _selectedMethod = "Selecciona un método";
  bool _isLoading = false;
  final ApiService _api = ApiService();

  // Colores del diseño oscuro de la imagen
  final Color _cardColor = const Color(0xFF101214);
  final Color _inputColor = const Color(0xFF0A0C0D);
  final Color _blueColor = const Color(0xFF3B82F6); // Azul brillante

  void _processRecharge() async {
    if (_amountCtrl.text.isEmpty) return;
    
    final amount = double.tryParse(_amountCtrl.text);
    if (amount == null || amount <= 0) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Monto inválido"), backgroundColor: Colors.red));
       return;
    }

    if (_selectedMethod == "Selecciona un método") {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Elige un método de pago"), backgroundColor: Colors.orange));
       return;
    }

    setState(() => _isLoading = true);

    // Llamada al API (Simulando integración con pasarela de pagos)
    final success = await _api.deposit(amount);

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        Navigator.pop(context, true); // Retorna true para recargar el Home
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("¡Recarga Exitosa!"), backgroundColor: Colors.green));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error al recargar"), backgroundColor: Colors.red));
      }
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
                Text("Recargar", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
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

            // MONTO
            Text("Monto a Recargar", style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 8),
            TextField(
              controller: _amountCtrl,
              keyboardType: TextInputType.number,
              style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: _inputColor,
                prefixIcon: const Icon(Icons.attach_money, color: Colors.white),
                suffixIcon: const Icon(Icons.unfold_more, color: Colors.grey), // Icono decorativo de selector
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                hintText: "0.00",
                hintStyle: TextStyle(color: Colors.grey.shade700),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),

            const SizedBox(height: 20),

            // MÉTODO DE PAGO
            Text("Método de Pago", style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: _inputColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedMethod,
                  dropdownColor: _cardColor,
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                  isExpanded: true,
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
                  items: <String>['Selecciona un método', 'PSE', 'Tarjeta Débito', 'Nequi', 'Puntos Colombia']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedMethod = newValue!;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 40),

            // BOTÓN RECARGAR
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _processRecharge,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _blueColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text("RECARGAR", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}