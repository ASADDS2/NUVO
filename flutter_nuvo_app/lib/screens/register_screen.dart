import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para el input de números
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import '../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controladores
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();

  final ApiService _api = ApiService();

  // Estado
  int _step = 1; // 1: Datos, 2: Verificación
  bool _isLoading = false;
  String _generatedOtp = ""; // Aquí guardamos el código secreto

  // PASO 1: SIMULAR ENVÍO DE CÓDIGO
  void _requestOtp() async {
    // Validaciones básicas
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passController.text.isEmpty ||
        _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor llena todos los campos"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simular espera de red (1.5 segundos)
    await Future.delayed(const Duration(milliseconds: 1500));

    // Generar código aleatorio de 4 dígitos
    _generatedOtp = (1000 + Random().nextInt(9000)).toString();

    setState(() {
      _isLoading = false;
      _step = 2; // Cambiar a pantalla de verificación
    });

    // MOSTRAR NOTIFICACIÓN FALSA (Simulando que llegó un WhatsApp)
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (c) => AlertDialog(
          backgroundColor: const Color(0xFFDCF8C6), // Verde WhatsApp
          title: Row(
            children: [
              const Icon(Icons.chat, color: Color(0xFF25D366)),
              const SizedBox(width: 10),
              Text(
                "WhatsApp",
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Mensaje de NUVO BANK:",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Tu código de verificación es: $_generatedOtp",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "(No lo compartas con nadie)",
                style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(c),
              child: const Text(
                "Cerrar",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      );
    }
  }

  // PASO 2: VERIFICAR CÓDIGO Y CREAR CUENTA REAL EN BACKEND
  // Esta es la función que faltaba y causaba el error
  void _verifyAndCreateAccount() async {
    // 1. Verificar que el código ingresado coincida con el generado
    if (_otpController.text != _generatedOtp) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("❌ Código incorrecto"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // 2. AQUÍ OCURRE LA MAGIA REAL: Llamamos al Backend Java para crear el usuario
    final result = await _api.register(
      _nameController.text,
      _emailController.text,
      _passController.text,
    );

    setState(() => _isLoading = false);

    // 3. Manejar la respuesta del servidor
    if (mounted) {
      if (result['success']) {
        // Éxito Total
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("🎉 ¡Cuenta Verificada y Creada!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // Volver al login automáticamente
      } else {
        // Fallo en el servidor (ej: email duplicado)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? "Error al crear usuario"),
            backgroundColor: Colors.red,
          ),
        );
        // Opcional: Si quieres que puedan reintentar sin volver a pedir código, no cambies _step
        // Si quieres que vuelvan a empezar: setState(() => _step = 1);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _step == 1 ? "Registro" : "Verificación",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2ECC71),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: _step == 1 ? _buildFormStep() : _buildOtpStep(),
      ),
    );
  }

  // UI del Paso 1: Formulario de Datos
  Widget _buildFormStep() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Crea tu cuenta",
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2C3E50),
            ),
          ),
          Text(
            "Verificaremos tu número celular.",
            style: GoogleFonts.poppins(color: Colors.grey),
          ),
          const SizedBox(height: 30),

          _buildInput(_nameController, "Nombre Completo", false, Icons.person),
          const SizedBox(height: 15),
          _buildInput(_emailController, "Email", false, Icons.email),
          const SizedBox(height: 15),
          // AHORA LA CLAVE ES NUMÉRICA Y DE 4 DÍGITOS
          _buildInput(_passController, "Contraseña", true, Icons.lock),
          const SizedBox(height: 15),
          _buildInput(
            _phoneController,
            "Celular",
            false,
            Icons.phone_android,
            isNumber: true,
          ),

          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _requestOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2ECC71),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      "ENVIAR CÓDIGO",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // UI del Paso 2: Ingreso de OTP
  Widget _buildOtpStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.security, size: 80, color: Color(0xFF2ECC71)),
        const SizedBox(height: 20),
        Text(
          "Ingresa el código",
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          "Enviado al ${_phoneController.text}",
          style: GoogleFonts.poppins(color: Colors.grey),
        ),

        const SizedBox(height: 30),
        TextField(
          controller: _otpController,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: 10,
          ),
          maxLength: 4,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            counterText: "",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF2ECC71), width: 2),
            ),
          ),
        ),

        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _verifyAndCreateAccount,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2C3E50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    "VERIFICAR",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),

        TextButton(
          onPressed: () => setState(() => _step = 1),
          child: const Text(
            "Cambiar número",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }

  // Widget auxiliar para inputs actualizado con maxLength
  Widget _buildInput(
    TextEditingController controller,
    String label,
    bool isPass,
    IconData icon, {
    bool isNumber = false,
    int? maxLength,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPass,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLength: maxLength,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF2ECC71)),
        labelText: label,
        counterText: "", // Ocultamos el contador de caracteres (ej: 0/4)
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2ECC71), width: 2),
        ),
      ),
    );
  }
}
