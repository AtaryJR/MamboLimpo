import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/providers/order_provider.dart';
import '../../../domain/entities/order_entity.dart';
import '../widgets/task_card.dart';

// Tela principal do Funcionario transformada com Design Premium e Responsivo
class HomeEmployeePage extends ConsumerWidget {
  const HomeEmployeePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escuta o provider que reage ao resultado da Promise/Future vinda do MockOrderRepository
    final ordersAsyncValue = ref.watch(employeeOrdersProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: CustomScrollView(
            slivers: [
              // Cabeçalho Premium Gradientizado (Foco Entregador com cor Diferenciada)
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 32),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blueGrey.shade800,
                        Colors.blueGrey.shade600,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Entregador - Mambo Limpo',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.white24,
                            child: IconButton(
                              icon: const Icon(Icons.delivery_dining, color: Colors.white),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Bom dia, Entregador! 🚚',
                        style: TextStyle(color: Colors.white70, fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Aqui estão suas\nRotas e Tarefas',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Área do Mapa e Conteúdo Variável
              SliverPadding(
                padding: const EdgeInsets.all(24.0),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Mapa Mock com Container Arredondado Sutil
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.map, size: 60, color: Colors.blueGrey),
                              SizedBox(height: 12),
                              Text('[Google Maps API Rota]', style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      const Text(
                        'Tarefas do Dia',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              // Trata os três estados da consulta Assíncrona no Sliver do Riverpod
              ordersAsyncValue.when(
                data: (orders) {
                  if (orders.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(
                          child: Text('Nenhum pedido hoje. Você está livre!', style: TextStyle(color: Colors.grey)),
                        ),
                      ),
                    );
                  }
                  
                  // Retorna um ListView Sliver apropriado para preencher o resto
                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final order = orders[index];
                          // Lógica Básica: Se o pedido está agendado (scheduled), é uma RECOLHA. Se não, é ENTREGA.
                          final isPickup = order.status == OrderStatus.scheduled;
                          
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: TaskCard(
                              title: isPickup ? 'Recolha: ${order.clientId}' : 'Entrega: ${order.clientId}', 
                              address: order.pickupAddress, 
                              time: '${order.scheduledDate.hour}h${order.scheduledDate.minute.toString().padLeft(2, '0')}', 
                              isPickup: isPickup,
                              orderStatus: order.status.name,
                              onActionPressed: () {},
                            ),
                          );
                        },
                        childCount: orders.length,
                      ),
                    ),
                  );
                },
                loading: () => const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (err, stack) => SliverFillRemaining(
                  child: Center(child: Text('Erro ao carregar dados: $err')),
                ),
              ),
              
              const SliverToBoxAdapter(child: SizedBox(height: 32)), // Padding do fundo
            ],
          ),
        ),
      ),
    );
  }
}
