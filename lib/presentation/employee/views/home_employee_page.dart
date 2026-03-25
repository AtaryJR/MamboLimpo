import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/providers/order_provider.dart';
import '../../../domain/entities/order_entity.dart';
import '../widgets/task_card.dart';

// Tela principal do Funcionario transformada com Design Premium e Responsivo
class HomeEmployeePage extends ConsumerStatefulWidget {
  const HomeEmployeePage({super.key});

  @override
  ConsumerState<HomeEmployeePage> createState() => _HomeEmployeePageState();
}

class _HomeEmployeePageState extends ConsumerState<HomeEmployeePage> {
  int _selectedTab = 0; // 0: Recolhas, 1: Entregas, 2: Concluídos

  @override
  Widget build(BuildContext context) {
    const employeeId = 'EMP-999';
    final ordersAsyncValue = ref.watch(employeeOrdersProvider(employeeId));

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: CustomScrollView(
            slivers: [
              // Cabeçalho Premium
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 60,
                    left: 24,
                    right: 24,
                    bottom: 32,
                  ),
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
                            'Mambo Limpo',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.logout,
                              color: Colors.white70,
                              size: 20,
                            ),
                            onPressed: () => context.go('/splash'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Minhas Tarefas 🚚',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Gestão de recolhas e entregas',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),

              // Visual de Mapa de Rota (Premium)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: Container(
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade900,
                      borderRadius: BorderRadius.circular(24),
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://images.unsplash.com/photo-1526778548025-fa2f459cd5c1?q=80&w=800&auto=format&fit=crop',
                        ),
                        fit: BoxFit.cover,
                        opacity: 0.4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.near_me,
                                color: Colors.white,
                                size: 40,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Visualização de Rota Dinâmica',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '8 recolhas pendentes hoje',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.my_location,
                              color: Colors.blueGrey.shade800,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Seletor de Abas (Filtros)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  child: Row(
                    children: [
                      _buildTab(0, 'Recolhas', Icons.download),
                      const SizedBox(width: 8),
                      _buildTab(1, 'Entregas', Icons.upload),
                      const SizedBox(width: 8),
                      _buildTab(2, 'Concluídos', Icons.check),
                    ],
                  ),
                ),
              ),

              ordersAsyncValue.when(
                data: (orders) {
                  // Filtragem baseada na aba selecionada
                  final filteredOrders = orders.where((o) {
                    if (_selectedTab == 0)
                      return o.status == OrderStatus.scheduled;
                    if (_selectedTab == 1) return o.status == OrderStatus.ready;
                    if (_selectedTab == 2)
                      return o.status == OrderStatus.delivered;
                    return false;
                  }).toList();

                  if (filteredOrders.isEmpty) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.assignment_turned_in_outlined,
                              size: 64,
                              color: Colors.grey.shade300,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Sem tarefas nesta categoria.',
                              style: TextStyle(color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final order = filteredOrders[index];
                        final isPickup = order.status == OrderStatus.scheduled;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: TaskCard(
                            title:
                                '${isPickup ? 'Recolha' : 'Entrega'}: ${order.id}',
                            address: order.pickupAddress,
                            time:
                                '${order.scheduledDate.hour}h${order.scheduledDate.minute.toString().padLeft(2, '0')}',
                            isPickup: isPickup,
                            orderStatus: order.status.name,
                            onTap: () {
                              context.push(
                                '/employee-task-detail',
                                extra: order,
                              );
                            },
                            onActionPressed: () async {
                              final nextStatus = isPickup
                                  ? OrderStatus.pickedUp
                                  : OrderStatus.delivered;
                              final repo = ref.read(orderRepositoryProvider);

                              // Simular progresso
                              await repo.updateOrderStatus(
                                order.id,
                                nextStatus,
                              );

                              // Atualizar a UI
                              ref.invalidate(
                                employeeOrdersProvider(employeeId),
                              );

                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      isPickup
                                          ? '📦 Pedido recolhido!'
                                          : '✅ Entrega concluída!',
                                    ),
                                    backgroundColor: Colors.blueGrey,
                                  ),
                                );
                              }
                            },
                          ),
                        );
                      }, childCount: filteredOrders.length),
                    ),
                  );
                },
                loading: () => const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (err, stack) => SliverFillRemaining(
                  child: Center(child: Text('Erro: $err')),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(int index, String label, IconData icon) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blueGrey.shade800 : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey,
                size: 18,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey,
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
