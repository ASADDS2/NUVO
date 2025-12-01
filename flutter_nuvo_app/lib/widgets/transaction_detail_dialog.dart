import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionDetailDialog extends StatelessWidget {
  final Map<String, dynamic> transaction;

  const TransactionDetailDialog({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    // Detectar si es ingreso o egreso
    final double amount = (transaction['amount'] as num).toDouble();
    final bool isDeposit = amount > 0;
    
    // Colores del tema oscuro
    const cardColor = Color(0xFF101214);
    const greenColor = Color(0xFF00C569);
    const redColor = Color(0xFFFF4C4C);
    final highlightColor = isDeposit ? greenColor : redColor;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF050505), // Fondo casi negro
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white10), // Borde sutil
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Encabezado con Cerrar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Detalle de Movimiento", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(color: Colors.white10, shape: BoxShape.circle),
                    child: const Icon(Icons.close, size: 18, color: Colors.white),
                  ),
                )
              ],
            ),
            
            const SizedBox(height: 30),

            // Icono Grande Circular
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: highlightColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isDeposit ? Icons.south_west : Icons.north_east,
                color: highlightColor,
                size: 30,
              ),
            ),

            const SizedBox(height: 16),

            // Tipo y Monto
            Text(
              transaction['type'].toString().toUpperCase(), 
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500, letterSpacing: 1)
            ),
            const SizedBox(height: 5),
            Text(
              "\$${amount.abs().toStringAsFixed(2)}",
              style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, color: highlightColor),
            ),

            const SizedBox(height: 30),

            // Tarjeta de Detalles
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _DetailRow(
                    icon: Icons.person_outline, 
                    label: "Destinatario/Origen", 
                    value: "Usuario NUVO", // Dato simulado
                    subValue: "**** 4521"
                  ),
                  const Divider(color: Colors.white10, height: 24),
                  _DetailRow(
                    icon: Icons.calendar_today_outlined, 
                    label: "Fecha y Hora", 
                    value: transaction['date'] ?? "Hoy",
                    subValue: "14:32 PM" // Hora simulada
                  ),
                  const Divider(color: Colors.white10, height: 24),
                  _DetailRow(
                    icon: Icons.tag, 
                    label: "Referencia", 
                    value: "TRF-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}",
                  ),
                  const Divider(color: Colors.white10, height: 24),
                  _DetailRow(
                    icon: Icons.description_outlined, 
                    label: "Descripción", 
                    value: transaction['description'] ?? "Movimiento bancario",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Botón Cerrar Grande
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: greenColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Text("CERRAR", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? subValue;

  const _DetailRow({required this.icon, required this.label, required this.value, this.subValue});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: const Color(0xFF050505), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: const Color(0xFF00C569), size: 20),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
              const SizedBox(height: 2),
              Text(value, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
              if (subValue != null)
                Text(subValue!, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
            ],
          ),
        )
      ],
    );
  }
}