import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PoolList extends StatelessWidget {
  final Function(Map<String, dynamic>) onPoolSelected;

  const PoolList({super.key, required this.onPoolSelected});

  final List<Map<String, dynamic>> pools = const [
    {"name": "Piscina Premium", "rate": "15%", "min": 500, "color": Color(0xFF00C569), "desc": "Alto rendimiento para inversores serios."},
    {"name": "Piscina Plus", "rate": "12%", "min": 100, "color": Color(0xFF3B82F6), "desc": "Balance ideal entre riesgo y retorno."},
    {"name": "Piscina Gold", "rate": "18%", "min": 1000, "color": Color(0xFFF59E0B), "desc": "Máxima rentabilidad a largo plazo."},
    {"name": "Piscina Express", "rate": "10%", "min": 50, "color": Color(0xFF10B981), "desc": "Inversión rápida y accesible."},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: pools.length,
      itemBuilder: (context, index) {
        final pool = pools[index];
        return GestureDetector(
          onTap: () => onPoolSelected(pool),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF101214),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5))]
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(pool['name'], style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 4),
                    Text("Mínimo: \$${pool['min']}", style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: (pool['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: pool['color'])
                  ),
                  child: Text(
                    "${pool['rate']} Anual", 
                    style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: pool['color'])
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}