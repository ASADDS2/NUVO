import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import 'dart:math';

class WithdrawDialog extends StatefulWidget {
  const WithdrawDialog({super.key});

  @override
  State<WithdrawDialog> createState() => _WithdrawDialogState();
}

class _WithdrawDialogState extends State<WithdrawDialog> {
  // Controladores
  final _amountCtrl = TextEditingController();
  final _confirmCodeCtrl = TextEditingController();

  // Estado
  int _step = 1; // 1: Monto, 2: Confirmación (Tu imagen), 3: Código Cajero
  bool _isLoading = false;

  // Datos
  String _selectedAccount = "Cuenta Principal (**** 3210)";
  String? _securityToken; // El código que se muestra para confirmar (887064)
  String? _finalAtmCode; // El código final para el cajero

  final ApiService _api = ApiService();

  // Colores del Diseño (Extraídos de tu imagen)
  final Color _cardColor = const Color(0xFF101214);
  final Color _inputColor = const Color(0xFF0A0C0D);
  final Color _accentOrange = const Color(
    0xFFD35400,
  ); // Naranja oscuro del botón
  final Color _textOrange = const Color(
    0xFFFF8C42,
  ); // Naranja brillante del texto

  // PASO 1 -> PASO 2
  void _goToConfirmation() {
    if (_amountCtrl.text.isEmpty) return;
    final amount = double.tryParse(_amountCtrl.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Monto inválido"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simular generación de token de seguridad
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _securityToken = (100000 + Random().nextInt(900000)).toString();
        _isLoading = false;
        _step = 2; // Ir a la pantalla de tu imagen
      });
    });
  }

  // PASO 2 -> PASO 3
  void _finalizeWithdraw() async {
    if (_confirmCodeCtrl.text != _securityToken) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Código incorrecto"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Llamada real al API (si estuviera conectada para retiros)
    await _api.deposit(-double.parse(_amountCtrl.text));

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _finalAtmCode = (100000 + Random().nextInt(900000))
          .toString(); // Código final
      _step = 3;
    });
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
        child: _buildCurrentStep(),
      ),
    );
  }

  Widget _buildCurrentStep() {
    if (_step == 1) return _buildAmountForm();
    if (_step == 2) return _buildConfirmationStep(); // <--- TU NUEVA PANTALLA
    return _buildFinalCode();
  }

  // --- PASO 1: INGRESAR MONTO ---
  Widget _buildAmountForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Retirar Dinero",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 18, color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        Text(
          "Monto a Retirar",
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _amountCtrl,
          keyboardType: TextInputType.number,
          style: GoogleFonts.poppins(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: _inputColor,
            prefixIcon: const Icon(Icons.attach_money, color: Colors.white),
            suffixIcon: const Icon(Icons.unfold_more, color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            hintText: "0.00",
            hintStyle: TextStyle(color: Colors.grey.shade700),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "Cuenta Origen",
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: _inputColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedAccount,
              dropdownColor: _cardColor,
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
              isExpanded: true,
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
              items:
                  <String>[
                        'Cuenta Principal (**** 3210)',
                        'Ahorros (**** 5501)',
                      ]
                      .map(
                        (String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ),
                      )
                      .toList(),
              onChanged: (newValue) =>
                  setState(() => _selectedAccount = newValue!),
            ),
          ),
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _goToConfirmation,
            style: ElevatedButton.styleFrom(
              backgroundColor: _accentOrange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    "CONTINUAR",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  // --- PASO 2: CONFIRMACIÓN DE SEGURIDAD (Tu Imagen) ---
  Widget _buildConfirmationStep() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Confirmar Retiro",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 18, color: Colors.white),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),
        Text(
          "Se ha generado un código de confirmación",
          style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13),
        ),
        const SizedBox(height: 20),

        // Caja del Código Generado
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _accentOrange, width: 1), // Borde Naranja
          ),
          child: Column(
            children: [
              Text(
                "Código de Confirmación",
                style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 5),
              Text(
                _securityToken ?? "Error",
                style: GoogleFonts.robotoMono(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 4,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Monto en Naranja
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Monto a retirar: ",
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
            Text(
              "\$${_amountCtrl.text}",
              style: GoogleFonts.poppins(
                color: _textOrange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Input para confirmar
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Ingresa el código para confirmar",
            style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _confirmCodeCtrl,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 6,
          style: GoogleFonts.robotoMono(
            fontSize: 24,
            color: Colors.white,
            letterSpacing: 8,
          ),
          decoration: InputDecoration(
            counterText: "",
            filled: true,
            fillColor: _inputColor,
            hintText: "000000",
            hintStyle: TextStyle(color: Colors.grey.shade800, letterSpacing: 8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _accentOrange),
            ),
          ),
        ),

        const SizedBox(height: 30),

        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _finalizeWithdraw,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(
                0xFF9A4618,
              ), // Naranja quemado (botón desactivado visualmente)
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    "CONFIRMAR RETIRO",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  // --- PASO 3: ÉXITO / CÓDIGO CAJERO ---
  Widget _buildFinalCode() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.check_circle, color: Color(0xFF2ECC71), size: 60),
        const SizedBox(height: 20),
        Text(
          "¡Retiro Autorizado!",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Usa este código en el cajero:",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
        ),

        const SizedBox(height: 30),

        Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white24),
          ),
          child: Text(
            _finalAtmCode ?? "----",
            style: GoogleFonts.robotoMono(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2ECC71),
              letterSpacing: 5,
            ),
          ),
        ),

        const SizedBox(height: 40),

        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context, true), // Cierra
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              "LISTO",
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
