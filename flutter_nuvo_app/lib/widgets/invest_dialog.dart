import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import '../theme/nuvo_theme.dart';

class InvestDialog extends StatefulWidget {
  final Map<String, dynamic> pool; // Datos de la piscina seleccionada

  const InvestDialog({super.key, required this.pool});

  @override
  State<InvestDialog> createState() => _InvestDialogState();
}

class _InvestDialogState extends State<InvestDialog> {
  final _amountCtrl = TextEditingController();
  bool _isLoading = false;
  final ApiService _api = ApiService();

  // Colores extraídos de tu imagen
  final Color _cardColor = const Color(0xFF101214);
  final Color _inputColor = const Color(0xFF0A0C0D);
  final Color _btnColor = const Color(0xFF4B5563); // Gris azulado del botón "Invertir"
  final Color _backBtnColor = Colors.transparent; // Botón transparente

  void _invest() async {
    if (_amountCtrl.text.isEmpty) return;
    final amount = double.tryParse(_amountCtrl.text);
    
    // Validar monto mínimo
    if (amount == null || amount < widget.pool['min']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("El monto mínimo es \$${widget.pool['min']}"), backgroundColor: Colors.red)
      );
      return;
    }

    setState(() => _isLoading = true);

    // Llamada al API (Simulada)
    await Future.delayed(const Duration(seconds: 2)); 
    // final success = await _api.invest(amount); // Descomentar para usar backend real

    setState(() => _isLoading = false);

    if (mounted) {
      Navigator.pop(context, true); // Éxito, devolvemos true
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("¡Inversión Exitosa!"), backgroundColor: NuvoColors.primary)
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
                Text("Monto a Invertir", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
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
            const SizedBox(height: 20),

            // INFO PISCINA SELECCIONADA (Recuadro con borde verde)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _inputColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: widget.pool['color'].withOpacity(0.5), width: 1)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Piscina Seleccionada", style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(widget.pool['name'], style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text("${widget.pool['rate']} Anual", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: widget.pool['color'])),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // INPUT MONTO
            Text("Monto a Invertir", style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 8),
            TextField(
              controller: _amountCtrl,
              keyboardType: TextInputType.number,
              style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: _inputColor,
                prefixIcon: const Icon(Icons.attach_money, color: Colors.white, size: 20),
                suffixIcon: const Icon(Icons.unfold_more, color: Colors.grey), 
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                hintText: "0.00",
                hintStyle: TextStyle(color: Colors.grey.shade700),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),

            const SizedBox(height: 20),

            // WARNING (Texto legal)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(8)),
              child: Text(
                "Invertir en piscinas implica riesgos. Por favor, lee los términos y condiciones.",
                style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey),
              ),
            ),

            const SizedBox(height: 30),

            // BOTONES (Atrás e Invertir)
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _backBtnColor,
                        elevation: 0,
                        side: BorderSide(color: Colors.white.withOpacity(0.2)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("ATRÁS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _invest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _btnColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _isLoading 
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text("INVERTIR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}