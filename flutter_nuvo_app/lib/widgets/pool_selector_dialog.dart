import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/nuvo_theme.dart';
import 'invest_dialog.dart'; // Este lo crearemos en el siguiente paso

class PoolSelectorDialog extends StatelessWidget {
  const PoolSelectorDialog({super.key});

  // Datos extraídos de tu imagen
  final List<Map<String, dynamic>> pools = const [
    {"name": "Piscina Premium", "rate": "15%", "min": 500, "color": Color(0xFF00C569)}, // Verde
    {"name": "Piscina Plus", "rate": "12%", "min": 100, "color": Color(0xFF3B82F6)},    // Azul
    {"name": "Piscina Gold", "rate": "18%", "min": 1000, "color": Color(0xFF10B981)},   // Teal
    {"name": "Piscina Express", "rate": "10%", "min": 50, "color": Color(0xFF34D399)},  // Verde claro
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF101214), // Fondo oscuro tarjeta
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Seleccionar Piscina", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.close, size: 16, color: Colors.white),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            
            // Lista de Opciones
            // Usamos .map para generar la lista de tarjetas
            ...pools.map((pool) => _buildPoolItem(context, pool)),
          ],
        ),
      ),
    );
  }

  Widget _buildPoolItem(BuildContext context, Map<String, dynamic> pool) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context); // Cerrar este selector
        
        // ABRIR EL SIGUIENTE PASO (Formulario de Inversión)
        // Nota: Crearemos 'InvestDialog' en el siguiente mensaje.
        showDialog(
          context: context,
          builder: (_) => InvestDialog(pool: pool),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF0A0C0D), // Fondo más oscuro para el item
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pool['name'], style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 4),
                Text("Mínimo: \$${pool['min']}", style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
              ],
            ),
            Text(
              "${pool['rate']} Anual", 
              style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: pool['color'])
            ),
          ],
        ),
      ),
    );
  }
}