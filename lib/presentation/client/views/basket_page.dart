import 'package:flutter/material.dart';
import '../../../domain/entities/basket_order.dart';

/// Página do Cesto: exibe pedidos agendados com cards expansíveis e NavBar com auto-hide
class BasketPage extends StatefulWidget {
  const BasketPage({super.key});

  @override
  State<BasketPage> createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage> {
  // Controla o scroll da lista
  final ScrollController _scrollController = ScrollController();

  // Qual card está expandido (-1 = nenhum)
  int _expandedIndex = -1;

  // Aba ativa na NavBar do Cesto
  int _navIndex = 1;

  /// Lista mockada de pedidos ativos no cesto
  final List<BasketOrder> orders = const [
    BasketOrder(
      id: '#ML-001',
      serviceType: 'Lavagem Normal',
      includeIroning: true,
      total: 7500,
      address: 'Rua da Missão, 14 – Luanda',
      scheduledDate: '21 Mar 2026',
      scheduledTime: '09:00',
      status: BasketStatus.aguardandoRecolha,
      items: [
        BasketItem(name: 'Camisa', quantity: 3, unitPrice: 800, emoji: '👔'),
        BasketItem(
          name: 'Calça Jeans',
          quantity: 2,
          unitPrice: 1200,
          emoji: '👖',
        ),
        BasketItem(
          name: 'Toalha de Banho',
          quantity: 2,
          unitPrice: 600,
          emoji: '🛁',
        ),
        BasketItem(
          name: 'Cueca/Calcinha',
          quantity: 4,
          unitPrice: 350,
          emoji: '🩲',
        ),
      ],
    ),
    BasketOrder(
      id: '#ML-002',
      serviceType: 'Lavagem a Seco',
      includeIroning: false,
      total: 12000,
      address: 'Av. 4 de Fevereiro, 201 – Luanda',
      scheduledDate: '22 Mar 2026',
      scheduledTime: '14:30',
      status: BasketStatus.emLavagem,
      items: [
        BasketItem(
          name: 'Fato Completo',
          quantity: 1,
          unitPrice: 5000,
          emoji: '🤵',
        ),
        BasketItem(name: 'Vestido', quantity: 2, unitPrice: 2500, emoji: '👗'),
        BasketItem(name: 'Casaco', quantity: 1, unitPrice: 2000, emoji: '🧥'),
      ],
    ),
    BasketOrder(
      id: '#ML-003',
      serviceType: 'Passar',
      includeIroning: false,
      total: 3500,
      address: 'Bairro Alvalade, 8 – Luanda',
      scheduledDate: '20 Mar 2026',
      scheduledTime: '11:00',
      status: BasketStatus.prontoParaEntrega,
      items: [
        BasketItem(
          name: 'Camisa Social',
          quantity: 5,
          unitPrice: 500,
          emoji: '👔',
        ),
        BasketItem(
          name: 'Calça Dress',
          quantity: 2,
          unitPrice: 500,
          emoji: '👖',
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

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
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      extendBody: true, // Permite o conteúdo ir por baixo da NavBar
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
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ),
                          const Text(
                            'Meu Cesto 🧺',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Acompanhe as suas roupas após\no agendamento até à recolha.',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      // Contadores rápidos
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

              // Lista de pedidos (cards expansíveis)
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
                            // Clique no mesmo card fecha, clique em outro expande
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
                            children: [
                              // Topo: ID + Badge de Status
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
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          order.id,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        // Indicador de expansão
                                        AnimatedRotation(
                                          turns: isExpanded ? 0.5 : 0,
                                          duration: const Duration(
                                            milliseconds: 300,
                                          ),
                                          child: Icon(
                                            Icons.keyboard_arrow_down,
                                            size: 20,
                                            color: color,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: color.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(icon, size: 13, color: color),
                                          const SizedBox(width: 5),
                                          Text(
                                            label,
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: color,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Detalhes básicos (sempre visíveis)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 14,
                                ),
                                child: Column(
                                  children: [
                                    _DetailRow(
                                      icon: Icons.local_laundry_service,
                                      label: 'Serviço',
                                      value: order.includeIroning
                                          ? '${order.serviceType} + Engomadoria'
                                          : order.serviceType,
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

                              // Secção expansível: lista de roupas selecionadas
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
                                        children: [
                                          Icon(
                                            Icons.list_alt_rounded,
                                            size: 16,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Roupas no Pedido (${order.items.length} tipos)',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      // Tabela de roupas
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
                                                  fontSize: 20,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Text(
                                                  item.name,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                      .withValues(alpha: 0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Text(
                                                  'x${item.quantity}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                    color: Theme.of(
                                                      context,
                                                    ).colorScheme.primary,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              SizedBox(
                                                width: 80,
                                                child: Text(
                                                  '${item.unitPrice * item.quantity} Kz',
                                                  textAlign: TextAlign.right,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Divider(height: 16),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Total do pedido:',
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
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                secondChild: const SizedBox.shrink(),
                              ),

                              // Rodapé: ação contextual
                              if (order.status != BasketStatus.emLavagem)
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    0,
                                    16,
                                    16,
                                  ),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton.icon(
                                      icon: Icon(
                                        order.status ==
                                                BasketStatus.prontoParaEntrega
                                            ? Icons.directions_bike
                                            : Icons.cancel_outlined,
                                        size: 18,
                                      ),
                                      label: Text(
                                        order.status ==
                                                BasketStatus.prontoParaEntrega
                                            ? 'Solicitar Entrega'
                                            : 'Cancelar Pedido',
                                      ),
                                      onPressed: () {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              order.status ==
                                                      BasketStatus
                                                          .prontoParaEntrega
                                                  ? '🚴 Entrega requisitada para ${order.id}!'
                                                  : '❌ Pedido ${order.id} cancelado.',
                                            ),
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                        );
                                      },
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor:
                                            order.status ==
                                                BasketStatus.prontoParaEntrega
                                            ? Theme.of(
                                                context,
                                              ).colorScheme.primary
                                            : Colors.red.shade400,
                                        side: BorderSide(
                                          color:
                                              order.status ==
                                                  BasketStatus.prontoParaEntrega
                                              ? Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                    .withValues(alpha: 0.4)
                                              : Colors.red.shade200,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                      ),
                                    ),
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

      // NavBar fixa — sempre visível na página do Cesto
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            currentIndex: _navIndex,
            elevation: 0,
            backgroundColor: Colors.white,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Colors.grey.shade400,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            onTap: (index) {
              setState(() => _navIndex = index);
              // Navegação entre abas do cliente
              if (index == 0) Navigator.of(context).pop();
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: 'Início',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_basket_outlined),
                label: 'Cesto',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded),
                label: 'Perfil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget auxiliar — estatística no cabeçalho
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
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}

/// Widget auxiliar — linha de detalhe com ícone no card
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
