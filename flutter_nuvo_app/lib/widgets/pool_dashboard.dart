import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import '../theme/nuvo_theme.dart';

class PoolDashboard extends StatefulWidget {
  final VoidCallback onWithdrawSuccess;

  const PoolDashboard({super.key, required this.onWithdrawSuccess});

  @override
  State<PoolDashboard> createState() => _PoolDashboardState();
}

class _PoolDashboardState extends State<PoolDashboard> {
  bool _isLoading = false;
  final ApiService _api = ApiService();

  // Datos simulados de la inversión activa
  final double _invested = 5000.00;
  final double _profit = 150.50;

  void _withdraw() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    // await _api.deposit(_invested + _profit); // Reembolso real
    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Retiro exitoso a tu cuenta"), backgroundColor: Colors.green));
      widget.onWithdrawSuccess(); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Tarjeta Principal
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF101214), Color(0xFF1E2228)]),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [BoxShadow(color: NuvoColors.primary.withOpacity(0.1), blurRadius: 20)]
            ),
            child: Column(
              children: [
                const Icon(Icons.verified, color: NuvoColors.primary, size: 50),
                const SizedBox(height: 20),
                Text("Tu Inversión Activa", style: GoogleFonts.poppins(color: Colors.white54)),
                Text("\$ ${(_invested + _profit).toStringAsFixed(2)}", style: GoogleFonts.poppins(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                  child: Text("+ \$${_profit.toStringAsFixed(2)} Ganancia", style: GoogleFonts.poppins(color: Colors.green, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          _DetailItem("Capital Inicial", "\$ $_invested"),
          _DetailItem("Piscina", "Premium (15%)"),
          _DetailItem("Fecha Inicio", "20 Nov 2025"),

          const SizedBox(height: 50),

          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _withdraw,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent.withOpacity(0.1),
                foregroundColor: Colors.redAccent,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Colors.redAccent)),
              ),
              child: const Text("RETIRAR CAPITAL Y GANANCIAS"),
            ),
          )
        ],
      ),
    );
  }

  Widget _DetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.poppins(color: Colors.grey, fontSize: 16)),
          Text(value, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}