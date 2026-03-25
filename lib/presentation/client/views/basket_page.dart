import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/basket_order.dart';
import '../providers/basket_provider.dart';
import '../widgets/client_bottom_nav_bar.dart';

/// Página do Cesto: exibe pedidos agendados consumindo o basketProvider
class BasketPage extends ConsumerStatefulWidget {
  const BasketPage({super.key});

  @override
  ConsumerState<BasketPage> createState() => _BasketPageState();
}

class _BasketPageState extends ConsumerState<BasketPage> {
  final ScrollController _scrollController = ScrollController();
  int _expandedIndex = -1;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  (IconData, Color, String) _statusInfo(BasketStatus status) {
    switch (status) {
      case BasketStatus.aguardandoRecolha:
        return (Icons.schedule, Colors.orange.shade600, 'Aguardando Recolha');
      case BasketStatus.emLavagem:
        return (
          Icons.local_laundry_service,
          Colors.blue.shade600,
          'Em Lavagem',
        );
      case BasketStatus.prontoParaEntrega:
        return (
          Icons.check_circle_outline,
          Colors.green.shade600,
          'Pronto p/ Entrega',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Escutando a lista de pedidos do provider global
    final orders = ref.watch(basketProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      extendBody: true,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Cabeçalho Premium
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 60,
                    left: 16,
                    right: 16,
                    bottom: 28,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.75),
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
                    children: [
                      const Text(
                        'Meu Cesto 🧺',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Acompanhe as suas roupas após\no agendamento até à recolha.',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      // Contadores rápidos baseados no estado real
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _HeaderStat(
                            value: orders.length.toString(),
                            label: 'No Cesto',
                            icon: Icons.shopping_basket_outlined,
                          ),
                          _HeaderStat(
                            value: orders
                                .where(
                                  (o) =>
                                      o.status ==
                                      BasketStatus.aguardandoRecolha,
                                )
                                .length
                                .toString(),
                            label: 'Aguardando',
                            icon: Icons.schedule,
                          ),
                          _HeaderStat(
                            value: orders
                                .where(
                                  (o) =>
                                      o.status ==
                                      BasketStatus.emLavagem,
                                )
                                .length
                                .toString(),
                            label: 'Lavagem',
                            icon: Icons.local_laundry_service,
                          ),
                          _HeaderStat(
                            value: orders
                                .where(
                                  (o) =>
                                      o.status ==
                                      BasketStatus.prontoParaEntrega,
                                )
                                .length
                                .toString(),
                            label: 'Prontos',
                            icon: Icons.check_circle_outline,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Lista de pedidos
              if (orders.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_basket_outlined,
                          size: 80,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'O seu cesto está vazio',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Agende um serviço para começar.',
                          style: TextStyle(color: Colors.grey.shade400),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final order = orders[index];
                      final (icon, color, label) = _statusInfo(order.status);
                      final isExpanded = _expandedIndex == index;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _expandedIndex = isExpanded ? -1 : index;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: isExpanded
                                    ? color.withValues(alpha: 0.12)
                                    : Colors.black.withValues(alpha: 0.05),
                                blurRadius: isExpanded ? 30 : 20,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Topo do Card
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: color.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(24),
                                    topRight: const Radius.circular(24),
                                    bottomLeft: Radius.circular(
                                      isExpanded ? 0 : 24,
                                    ),
                                    bottomRight: Radius.circular(
                                      isExpanded ? 0 : 24,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Pedido #${orders.length - index}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            order.serviceType,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Icon(
                                                icon,
                                                size: 14,
                                                color: color,
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                label,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: color,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    AnimatedRotation(
                                      turns: isExpanded ? 0.5 : 0,
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: color.withValues(alpha: 0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.keyboard_arrow_down,
                                          size: 24,
                                          color: color,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Detalhes básicos
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 14,
                                ),
                                child: Column(
                                  children: [
                                    _DetailRow(
                                      icon: Icons.add_circle_outline,
                                      label: 'Serviço Adicional',
                                      value: order.includeIroning
                                          ? 'Engomadoria'
                                          : 'Nenhum',
                                    ),
                                    const SizedBox(height: 10),
                                    _DetailRow(
                                      icon: Icons.location_on_outlined,
                                      label: 'Recolha',
                                      value: order.address,
                                    ),
                                    const SizedBox(height: 10),
                                    _DetailRow(
                                      icon: Icons.calendar_today_outlined,
                                      label: 'Agendado',
                                      value:
                                          '${order.scheduledDate} às ${order.scheduledTime}',
                                    ),
                                  ],
                                ),
                              ),

                              // Secção expansível
                              AnimatedCrossFade(
                                duration: const Duration(milliseconds: 280),
                                crossFadeState: isExpanded
                                    ? CrossFadeState.showFirst
                                    : CrossFadeState.showSecond,
                                firstChild: Container(
                                  margin: const EdgeInsets.fromLTRB(
                                    16,
                                    0,
                                    16,
                                    12,
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Itens do Pedido',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                            ),
                                          ),
                                          Text(
                                            order.id,
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey.shade400,
                                              fontFamily: 'monospace',
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      ...order.items.map(
                                        (item) => Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 8,
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                item.emoji,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  item.name,
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                'x${item.quantity}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Divider(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Total:',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '${order.total} Kz',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.secondary,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                secondChild: const SizedBox.shrink(),
                              ),

                              // Ações do Pedido
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  0,
                                  16,
                                  16,
                                ),
                                child: Column(
                                  children: [
                                    if (order.status ==
                                        BasketStatus.aguardandoRecolha)
                                      SizedBox(
                                        width: double.infinity,
                                        child: OutlinedButton.icon(
                                          icon: const Icon(
                                            Icons.cancel_outlined,
                                            size: 18,
                                          ),
                                          label: const Text('Cancelar Pedido'),
                                          onPressed: () {
                                            ref
                                                .read(basketProvider.notifier)
                                                .cancelOrder(order.id);
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Pedido cancelado.',
                                                ),
                                              ),
                                            );
                                          },
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: Colors.red,
                                            side: const BorderSide(
                                              color: Colors.redAccent,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                        ),
                                      ),
                                    if (order.status ==
                                        BasketStatus.prontoParaEntrega)
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton.icon(
                                          icon: const Icon(
                                            Icons.delivery_dining,
                                            color: Colors.white,
                                          ),
                                          label: const Text(
                                            'Solicitar Entrega Agora',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          onPressed: () {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  '🚴 Entrega solicitada para ${order.id}!',
                                                ),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.green.shade600,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }, childCount: orders.length),
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const ClientBottomNavBar(currentIndex: 1),
    );
  }
}

class _HeaderStat extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  const _HeaderStat({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '$label: $value',
            style: const TextStyle(fontSize: 13, color: Colors.black87),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
