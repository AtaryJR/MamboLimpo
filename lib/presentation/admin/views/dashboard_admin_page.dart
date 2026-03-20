import 'package:flutter/material.dart';
import '../widgets/stat_card.dart';
import '../widgets/order_row.dart';

// Dashboard Administrativo focando em gestão de relatórios com Design Premium
class DashboardAdminPage extends StatelessWidget {
  const DashboardAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Menu lateral administrativo com visual luxuoso
    final drawerContent = Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, bottom: 30, left: 24, right: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.indigo.shade800,
                  Colors.indigo.shade500,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(30),
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white24,
                  radius: 30,
                  child: Icon(Icons.admin_panel_settings, color: Colors.white, size: 32),
                ),
                SizedBox(height: 16),
                Text('Painel Admin', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                Text('Gestão Executiva', style: TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: const [
                ListTile(leading: Icon(Icons.dashboard, color: Colors.indigo), title: Text('Resumo (Dashboard)', style: TextStyle(fontWeight: FontWeight.bold))),
                ListTile(leading: Icon(Icons.people, color: Colors.grey), title: Text('Gestão de Clientes', style: TextStyle(color: Colors.black87))),
                ListTile(leading: Icon(Icons.delivery_dining, color: Colors.grey), title: Text('Gestão de Entregadores', style: TextStyle(color: Colors.black87))),
                ListTile(leading: Icon(Icons.attach_money, color: Colors.grey), title: Text('Faturamento', style: TextStyle(color: Colors.black87))),
              ],
            ),
          ),
        ],
      ),
    );

    // Conteúdo principal do Dashboard encapsulado (Premium)
    final dashboardBody = Container(
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Visão Geral de Hoje', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.black87)),
            const SizedBox(height: 24),
            
            // Layout flexível (Wrap) para adaptar melhor os widgets a telas responsivas
            Wrap(
              spacing: 24,
              runSpacing: 24,
              children: [
                const StatCard(title: 'Entregas Realizadas', value: '15', color: Colors.green),
                const StatCard(title: 'Pedidos em Análise', value: '4', color: Colors.orange),
                const StatCard(title: 'Receita (Hoje)', value: '125.000 Kz', color: Colors.indigo),
              ],
            ),
            
            const SizedBox(height: 48),
            const Text('Pedidos Recentes', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 16),
            
            // Simulação de uma Tabela de Dados (DataGrid)
            Expanded(
              child: ListView(
                children: const [
                   OrderRow(id: 'ORD-001', client: 'João Silva', service: 'Lavagem Completa', status: 'Em Transito'),
                   OrderRow(id: 'ORD-002', client: 'Maria Souza', service: 'Passadoria', status: 'Aguardando Pagamento'),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        // Breakpoint para telas maiores que Tablets (800 pixels)
        final isDesktop = constraints.maxWidth > 800;

        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          appBar: isDesktop ? null : AppBar(
            title: const Text('Dashboard', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            backgroundColor: Colors.indigo.shade800,
            iconTheme: const IconThemeData(color: Colors.white),
            elevation: 0,
          ),
          // No Desktop não usamos Drawer sobreposto, no Mobile sim
          drawer: isDesktop ? null : Drawer(child: drawerContent),
          body: isDesktop
              ? Row(
                  children: [
                    // Na Versão Desktop a barra fica fixada na lateral com efeito sutil
                    Container(
                      width: 280,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 15,
                            offset: const Offset(5, 0),
                          ),
                        ],
                      ),
                      child: drawerContent,
                    ),
                    Expanded(child: dashboardBody),
                  ],
                )
              : dashboardBody, // Na Versão Mobile, apenas o corpo é mostrado no lugar principal
        );
      },
    );
  }
}
