import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // --- BASE DE DATOS SIMULADA (En Memoria) ---
  static double _mockBalance = 12500.50;
  static final List<Map<String, dynamic>> _mockTransactions = [
    {
      "type": "TRANSFERENCIA",
      "amount": -200.00,
      "date": "2025-11-25T10:00:00",
      "description": "Pago de servicios"
    },
    {
      "type": "DEPÓSITO",
      "amount": 1500.00,
      "date": "2025-11-24T14:30:00",
      "description": "Nómina Noviembre"
    },
    {
      "type": "PISCINA",
      "amount": -500.00,
      "date": "2025-11-20T09:15:00",
      "description": "Inversión Crypto"
    },
  ];

  // --- AUTH ---
  Future<Map<String, dynamic>> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simular red
    if (password == "1234" || password.length >= 4) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', "Usuario Nuvo");
      return {'success': true};
    }
    return {'success': false, 'message': 'Credenciales incorrectas'};
  }

  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', name);
    return {'success': true};
  }

  // --- DATA ---
  Future<Map<String, dynamic>> getAccountData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {
      'balance': _mockBalance,
      'accountNumber': '9876543210'
    };
  }

  Future<List<dynamic>> getHistory() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_mockTransactions); // Devolver copia
  }

  // --- ACTIONS (Modifican el saldo local) ---
  
  // Depósitos y Retiros
  Future<bool> deposit(double amount) async {
    await Future.delayed(const Duration(seconds: 1));
    _mockBalance += amount;
    _mockTransactions.insert(0, {
      "type": amount > 0 ? "DEPÓSITO" : "RETIRO",
      "amount": amount,
      "date": DateTime.now().toIso8601String(),
      "description": amount > 0 ? "Recarga Manual" : "Retiro Cajero"
    });
    return true;
  }

  // Transferencias
  Future<bool> transfer(int targetId, double amount) async {
    await Future.delayed(const Duration(seconds: 2));
    if (_mockBalance >= amount) {
      _mockBalance -= amount;
      _mockTransactions.insert(0, {
        "type": "TRANSFERENCIA",
        "amount": -amount,
        "date": DateTime.now().toIso8601String(),
        "description": "Envío a ID $targetId"
      });
      return true;
    }
    return false; // Saldo insuficiente
  }

  // Inversiones
  Future<bool> invest(double amount) async {
    await Future.delayed(const Duration(seconds: 1));
    if (_mockBalance >= amount) {
      _mockBalance -= amount;
      _mockTransactions.insert(0, {
        "type": "PISCINA",
        "amount": -amount,
        "date": DateTime.now().toIso8601String(),
        "description": "Inversión Pool"
      });
      return true;
    }
    return false;
  }

  // Préstamos (Suman saldo)
  Future<bool> requestLoan(double amount) async {
    await Future.delayed(const Duration(seconds: 2));
    _mockBalance += amount;
    _mockTransactions.insert(0, {
      "type": "PRÉSTAMO",
      "amount": amount,
      "date": DateTime.now().toIso8601String(),
      "description": "Desembolso Aprobado"
    });
    return true;
  }
  
  // Stats de Piscina
  Future<Map<String, dynamic>> getPoolStats() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {'totalInvested': 5000.0, 'currentProfit': 150.50};
  }
}