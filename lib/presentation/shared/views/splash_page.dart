import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Tela inicial para simular a seleção de perfis (Área do Cliente, Funcionário, Admin)
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Ícone principal do aplicativo
              Icon(Icons.local_laundry_service, size: 80, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 16),
              // Nome da App
              const Text(
                'Mambo Limpo',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              const Text(
                'Bem-vindo! Escolha seu perfil de acesso:',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              
              // Botão para o fluxo do Cliente
              ElevatedButton.icon(
                onPressed: () => context.go('/client-home'),
                icon: const Icon(Icons.person),
                label: const Text('Entrar como Cliente'),
                style: _buttonStyle(context),
              ),
              const SizedBox(height: 16),
              
              // Botão para o fluxo do Funcionário (Entregador)
              ElevatedButton.icon(
                onPressed: () => context.go('/employee-home'),
                icon: const Icon(Icons.delivery_dining),
                label: const Text('Entrar como Funcionário'),
                style: _buttonStyle(context),
              ),
              const SizedBox(height: 16),
              
              // Botão para o fluxo do Administrador
              ElevatedButton.icon(
                onPressed: () => context.go('/admin-dashboard'),
                icon: const Icon(Icons.admin_panel_settings),
                label: const Text('Entrar como Admin'),
                style: _buttonStyle(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Estilo padronizado para os botões desta tela (cores e cantos arredondados)
  ButtonStyle _buttonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
