import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/nuvo_theme.dart';
import '../widgets/transaction_detail_dialog.dart';
import '../widgets/recharge_dialog.dart';
import '../widgets/withdraw_dialog.dart';
import '../widgets/loan_dialog.dart';
import '../widgets/pool_selector_dialog.dart'; // <--- IMPORTANTE: Listado de piscinas
import 'login_screen.dart';
import 'transfer_screen.dart';
import 'loan_screen.dart'; // Si no lo usas en favor del diálogo, puedes borrarlo
import 'pool_screen.dart'; // Dashboard de inversión activa

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // --- DATOS MOCK (ESTÁTICOS POR AHORA) ---
  double _balance = 12500.50;
  final String _userName = "Usuario Nuvo";
  final String _accountNumber = "3210"; // Últimos 4 dígitos

  // Lista de transacciones
  final List<Map<String, dynamic>> _transactions = [
    {
      "type": "TRANSFERENCIA",
      "amount": -200.00,
      "date": "25 Nov 2025",
      "description": "Pago de servicios"
    },
    {
      "type": "DEPÓSITO",
      "amount": 1500.00,
      "date": "24 Nov 2025",
      "description": "Nómina Noviembre"
    },
    {
      "type": "PISCINA",
      "amount": -500.00,
      "date": "20 Nov 2025",
      "description": "Inversión Crypto"
    },
    {
      "type": "PRÉSTAMO",
      "amount": 5000.00,
      "date": "15 Nov 2025",
      "description": "Desembolso rápido"
    },
  ];

  // --- FUNCIONES ---

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (c) => const LoginScreen())
      );
    }
  }

  // Función simulada para recargar datos
  void _refreshData() {
    setState(() {
      // Aquí iría la llamada al API
    });
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFF050505);        
    const cardDarkColor = Color(0xFF101214);  
    const accentGreen = Color(0xFF00C569);    
    
    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- 1. HEADER VERDE ASIMÉTRICO ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 80), 
              decoration: const BoxDecoration(
                color: accentGreen,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(60), 
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fila Superior: Avatar y Logout
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle
                            ),
                            child: const Icon(Icons.person_outline, color: Colors.white),
                          ),
                          const SizedBox(width: 12),
                          Text("Hola, $_userName", style: GoogleFonts.poppins(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500)),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout_rounded, color: Colors.white),
                        onPressed: _logout,
                      )
                    ],
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Saldo
                  Text("Saldo Disponible", style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.8), fontSize: 14)),
                  const SizedBox(height: 5),
                  Text(
                    "\$ ${_balance.toStringAsFixed(2)}", 
                    style: GoogleFonts.poppins(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold)
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Cuenta: **** $_accountNumber", 
                    style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.6), fontSize: 14)
                  ),
                ],
              ),
            ),

            // --- 2. MENÚ FLOTANTE (Solapado) ---
            Transform.translate(
              offset: const Offset(0, -50), 
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  decoration: BoxDecoration(
                    color: cardDarkColor,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20, offset: const Offset(0, 10))
                    ]
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // 1. ENVIAR -> TransferScreen (Pantalla completa)
                      _MenuButton(
                        icon: Icons.send_outlined, 
                        label: "Enviar", 
                        color: const Color(0xFF00C569), // Verde
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TransferScreen()))
                      ),
                      
                      // 2. RECARGAR -> RechargeDialog (Modal)
                      _MenuButton(
                        icon: Icons.account_balance_wallet_outlined, 
                        label: "Recargar", 
                        color: const Color(0xFF3B82F6), // Azul
                        onTap: () async {
                           final res = await showDialog(context: context, builder: (_) => const RechargeDialog());
                           if (res == true) _refreshData();
                        }
                      ),
                      
                      // 3. RETIRAR -> WithdrawDialog (Modal)
                      _MenuButton(
                        icon: Icons.attach_money, 
                        label: "Retirar", 
                        color: const Color(0xFFF97316), // Naranja
                        onTap: () async {
                           final res = await showDialog(context: context, builder: (_) => const WithdrawDialog());
                           if (res == true) _refreshData();
                        }
                      ),
                      
                      // 4. PRÉSTAMOS -> LoanDialog (Modal)
                      _MenuButton(
                        icon: Icons.account_balance_outlined, 
                        label: "Préstamos", 
                        color: const Color(0xFF8B5CF6), // Morado
                        onTap: () async {
                           final res = await showDialog(context: context, builder: (_) => const LoanDialog());
                           // Si aprobó, podrías refrescar
                        }
                      ),
                      
                      // 5. PISCINA -> PoolSelectorDialog / PoolScreen
                      _MenuButton(
                        icon: Icons.water_drop_outlined, 
                        label: "Piscina", 
                        color: const Color(0xFF10B981), // Teal
                        onTap: () {
                          // Lógica: Si quieres que vaya directo al Dashboard de Inversión (PoolScreen)
                          // o si quieres que abra el selector de piscinas primero (PoolSelectorDialog)
                          
                          // OPCIÓN A: Ir al Dashboard principal de Pool (Que maneja el flujo interno)
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const PoolScreen())).then((_) => _refreshData());

                          // OPCIÓN B: Abrir directamente el selector (Modal)
                          // showDialog(context: context, builder: (_) => const PoolSelectorDialog());
                        }
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // --- 3. LISTA DE MOVIMIENTOS ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Align(
                alignment: Alignment.centerLeft, 
                child: Text(
                  "Movimientos Recientes", 
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)
                )
              ),
            ),
            
            const SizedBox(height: 16),

            ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final t = _transactions[index];
                final isPositive = (t['amount'] as double) > 0;
                
                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context, 
                      builder: (_) => TransactionDetailDialog(transaction: t) 
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardDarkColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        // Icono
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isPositive ? const Color(0xFF0F291E) : const Color(0xFF2A1215), 
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            isPositive ? Icons.south_west : Icons.north_east, 
                            color: isPositive ? const Color(0xFF00C569) : const Color(0xFFFF4C4C),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 16),
                        
                        // Detalles
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(t['type'], style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
                              const SizedBox(height: 4),
                              Text(t['description'], style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                        ),

                        // Monto
                        Text(
                          "${isPositive ? '+' : ''} \$${t['amount'].abs().toStringAsFixed(2)}",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: isPositive ? const Color(0xFF00C569) : const Color(0xFFFF4C4C), 
                            fontSize: 16
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// Widget auxiliar para botones cuadrados
class _MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _MenuButton({
    required this.icon, 
    required this.label, 
    required this.color,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 50, 
            height: 50,
            decoration: BoxDecoration(
              color: color, 
              borderRadius: BorderRadius.circular(16), 
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label, 
          style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500)
        )
      ],
    );
  }
}