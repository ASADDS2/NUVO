import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/pool_list.dart';
import '../widgets/pool_invest_form.dart';
import '../widgets/pool_dashboard.dart';

class PoolScreen extends StatefulWidget {
  const PoolScreen({super.key});

  @override
  State<PoolScreen> createState() => _PoolScreenState();
}

class _PoolScreenState extends State<PoolScreen> {
  // 0: Lista, 1: Formulario, 2: Dashboard
  int _currentStep = 0; 
  Map<String, dynamic>? _selectedPool;
  bool _hasActiveInvestment = false; // Simulación

  @override
  Widget build(BuildContext context) {
    // Si ya tiene inversión, ir directo al dashboard
    if (_hasActiveInvestment && _currentStep == 0) _currentStep = 2;

    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      appBar: AppBar(
        title: Text(_getTitle(), style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: _currentStep == 0 || _currentStep == 2, 
      ),
      body: _buildBody(),
    );
  }

  String _getTitle() {
    switch (_currentStep) {
      case 0: return "Piscinas NUVO";
      case 1: return "Invertir";
      case 2: return "Mi Inversión";
      default: return "Inversiones";
    }
  }

  Widget _buildBody() {
    if (_currentStep == 2) {
      return PoolDashboard(
        onWithdrawSuccess: () {
          setState(() {
            _hasActiveInvestment = false;
            _currentStep = 0;
          });
        },
      );
    } else if (_currentStep == 1 && _selectedPool != null) {
      return PoolInvestForm(
        pool: _selectedPool!,
        onBack: () => setState(() => _currentStep = 0),
        onInvestSuccess: () {
          setState(() {
            _hasActiveInvestment = true;
            _currentStep = 2;
          });
        },
      );
    } else {
      return PoolList(
        onPoolSelected: (pool) {
          setState(() {
            _selectedPool = pool;
            _currentStep = 1;
          });
        },
      );
    }
  }
}