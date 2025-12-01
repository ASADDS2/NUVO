import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/nuvo_theme.dart';

class LoanScreen extends StatefulWidget {
  const LoanScreen({super.key});

  @override
  State<LoanScreen> createState() => _LoanScreenState();
}

class _LoanScreenState extends State<LoanScreen> {
  // Controladores
  final _amountController = TextEditingController();
  
  // Estado de la simulación
  int _selectedMonths = 12; // Plazo por defecto
  double _interestRate = 0.05; // 5% de interés mensual (Fijo para demo)
  bool _isLoading = false;

  // --- CÁLCULOS EN TIEMPO REAL ---
  double get _amount => double.tryParse(_amountController.text) ?? 0.0;
  double get _totalInterest => _amount * _interestRate * _selectedMonths;
  double get _totalToPay => _amount + _totalInterest;
  double get _monthlyPayment => _selectedMonths > 0 ? _totalToPay / _selectedMonths : 0;

  // Lógica de Envío (Simulada)
  void _submitRequest() async {
    if (_amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ingresa un monto válido"), backgroundColor: Colors.orange)
      );
      return;
    }

    setState(() => _isLoading = true);

    // 1. SIMULAMOS TIEMPO DE ESPERA DEL SERVIDOR
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    // 2. MOSTRAR ÉXITO
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (c) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Column(
            children: [
              const Icon(Icons.check_circle, color: NuvoColors.primary, size: 60),
              const SizedBox(height: 10),
              Text("¡Solicitud Enviada!", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            ],
          ),
          content: const Text(
            "Tu préstamo pre-aprobado está en revisión. (Modo Simulación)",
            textAlign: TextAlign.center,
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(c); // Cerrar diálogo
                Navigator.pop(context); // Volver al Dashboard
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: NuvoColors.dark,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("ENTENDIDO", style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Pedir Préstamo", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: NuvoColors.dark)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: NuvoColors.dark),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Simula tu crédito", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: NuvoColors.dark)),
            Text("Elige cuánto necesitas y cuándo pagarlo.", style: GoogleFonts.poppins(color: Colors.grey)),
            
            const SizedBox(height: 30),

            // 1. INPUT MONTO
            Text("¿Cuánto dinero necesitas?", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              // Actualiza la UI cada vez que escribes para recalcular cuotas
              onChanged: (val) => setState(() {}), 
              style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: NuvoColors.primary),
              decoration: InputDecoration(
                prefixText: "\$ ",
                hintText: "0.00",
                hintStyle: TextStyle(color: Colors.grey.shade300),
                prefixStyle: const TextStyle(color: NuvoColors.primary, fontSize: 24, fontWeight: FontWeight.bold),
                filled: true,
                fillColor: NuvoColors.background,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
            ),

            const SizedBox(height: 30),

            // 2. SLIDER PLAZO
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Plazo:", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                Text("$_selectedMonths meses", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: NuvoColors.primary, fontSize: 18)),
              ],
            ),
            Slider(
              value: _selectedMonths.toDouble(),
              min: 1,
              max: 12,
              divisions: 11,
              activeColor: NuvoColors.primary,
              inactiveColor: Colors.grey.shade200,
              onChanged: (val) {
                setState(() => _selectedMonths = val.toInt());
              },
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("1 mes", style: TextStyle(color: Colors.grey, fontSize: 12)),
                Text("12 meses", style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),

            const SizedBox(height: 40),

            // 3. TARJETA RESUMEN
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: NuvoColors.dark,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: NuvoColors.primary.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))]
              ),
              child: Column(
                children: [
                  _resumenRow("Tasa de Interés", "${(_interestRate * 100).toInt()}% Mensual"),
                  const Divider(color: Colors.white24),
                  _resumenRow("Intereses totales", "\$ ${_totalInterest.toStringAsFixed(2)}"),
                  const Divider(color: Colors.white24),
                  _resumenRow("Cuota Mensual aprox.", "\$ ${_monthlyPayment.toStringAsFixed(2)}", isBold: true),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("TOTAL A PAGAR", style: TextStyle(color: Colors.white70)),
                      Text("\$ ${_totalToPay.toStringAsFixed(2)}", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: NuvoColors.primary)),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 4. BOTÓN ENVIAR SOLICITUD
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitRequest,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  backgroundColor: NuvoColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 5,
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("ENVIAR SOLICITUD", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _resumenRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(value, style: GoogleFonts.poppins(color: Colors.white, fontWeight: isBold ? FontWeight.bold : FontWeight.normal, fontSize: isBold ? 16 : 14)),
        ],
      ),
    );
  }
}