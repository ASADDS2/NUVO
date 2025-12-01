import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import '../theme/nuvo_theme.dart';

class PoolInvestForm extends StatefulWidget {
  final Map<String, dynamic> pool;
  final VoidCallback onInvestSuccess;
  final VoidCallback onBack;

  const PoolInvestForm({super.key, required this.pool, required this.onInvestSuccess, required this.onBack});

  @override
  State<PoolInvestForm> createState() => _PoolInvestFormState();
}

class _PoolInvestFormState extends State<PoolInvestForm> {
  final _amountCtrl = TextEditingController();
  bool _isLoading = false;
  final ApiService _api = ApiService();

  // Colores del diseño
  final Color _inputColor = const Color(0xFF0A0C0D);
  final Color _confirmColor = const Color(0xFF4B5563); // Gris azulado

  void _invest() async {
    if (_amountCtrl.text.isEmpty) return;
    final amount = double.tryParse(_amountCtrl.text);
    
    if (amount == null || amount < widget.pool['min']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("El monto mínimo es \$${widget.pool['min']}"), backgroundColor: Colors.red)
      );
      return;
    }

    setState(() => _isLoading = true);

    // Llamada simulada o real al API
    await Future.delayed(const Duration(seconds: 2)); 
    // final success = await _api.invest(amount); // Descomentar para real

    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("¡Bienvenido a la Piscina!"), backgroundColor: NuvoColors.primary)
      );
      widget.onInvestSuccess(); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título
          Text("Monto a Invertir", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 20),

          // Info Piscina
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _inputColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: widget.pool['color'].withOpacity(0.5))
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Piscina Seleccionada", style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(widget.pool['name'], style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 4),
                Text("${widget.pool['rate']} Anual", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: widget.pool['color'])),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Input
          Text("Monto a Invertir", style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 10),
          TextField(
            controller: _amountCtrl,
            keyboardType: TextInputType.number,
            style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: _inputColor,
              prefixIcon: const Icon(Icons.attach_money, color: Colors.white),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              hintText: "0.00",
              hintStyle: TextStyle(color: Colors.grey.shade700),
            ),
          ),

          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(8)),
            child: Text(
              "Invertir en piscinas implica riesgos. Lee los términos y condiciones.",
              style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 30),

          // Botones
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: widget.onBack,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
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
                      backgroundColor: _confirmColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isLoading 
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text("INVERTIR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}