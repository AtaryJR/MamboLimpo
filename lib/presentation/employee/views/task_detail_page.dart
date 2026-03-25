import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../domain/entities/order_entity.dart';
import '../../shared/providers/order_provider.dart';

class TaskDetailPage extends ConsumerWidget {
  final OrderEntity order;

  const TaskDetailPage({super.key, required this.order});

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const employeeId = 'EMP-999';
    final primaryColor = Colors.blueGrey.shade800;

    return Scaffold(
      body: Stack(
        children: [
          // 1. Mapa de Rota em Tela Inteira (Mock)
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1526778548025-fa2f459cd5c1?q=80&w=1200&auto=format&fit=crop',
              fit: BoxFit.cover,
            ),
          ),

          // 2. Overlay Gradiente para o topo (Voltar)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 120,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.6),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // 3. Botão Voltar
          Positioned(
            top: 50,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 18,
                  color: Colors.black,
                ),
                onPressed: () => context.pop(),
              ),
            ),
          ),

          // 4. Painel de Detalhes (BottomSheet Persistente)
          DraggableScrollableSheet(
            initialChildSize: 0.45,
            minChildSize: 0.4,
            maxChildSize: 0.85,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 24),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pedido #${order.id}',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  order.status == OrderStatus.scheduled
                                      ? 'Recolha Agendada'
                                      : 'Entrega Pendente',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _buildStatusBadge(order.status),
                        ],
                      ),

                      const Divider(height: 40),

                      // Mapa de Rota Simulado com Texto
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade50,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.near_me, color: Colors.blueGrey),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Rota optimizada: 12 min até ao destino',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () => _launchURL(
                                'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(order.pickupAddress)}',
                              ),
                              child: const Text('ABRIR GPS'),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      _buildInfoRow(
                        Icons.person_outline,
                        'Cliente',
                        'ID: ${order.clientId}',
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        Icons.location_on_outlined,
                        'Morada',
                        order.pickupAddress,
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        Icons.local_laundry_service_outlined,
                        'Serviço',
                        order.serviceName,
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        Icons.payments_outlined,
                        'Valor Total',
                        'KZ ${order.totalAmount.toStringAsFixed(2)}',
                      ),

                      const SizedBox(height: 32),

                      // Ações: Contacto e Status
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionButton(
                              onPressed: () => _launchURL('tel:+244900000000'),
                              icon: Icons.phone,
                              label: 'Ligar',
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildActionButton(
                              onPressed: () =>
                                  _launchURL('https://wa.me/244900000000'),
                              icon: Icons.chat_bubble_outline,
                              label: 'WhatsApp',
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () async {
                            final isPickup =
                                order.status == OrderStatus.scheduled;
                            final nextStatus = isPickup
                                ? OrderStatus.pickedUp
                                : OrderStatus.delivered;
                            final repo = ref.read(orderRepositoryProvider);

                            await repo.updateOrderStatus(order.id, nextStatus);
                            ref.invalidate(employeeOrdersProvider(employeeId));

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isPickup
                                        ? '📦 Pedido recolhido!'
                                        : '✅ Entrega concluída!',
                                  ),
                                ),
                              );
                              context.pop();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            order.status == OrderStatus.scheduled
                                ? 'CONFIRMAR RECOLHA'
                                : 'CONFIRMAR ENTREGA',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.blueGrey.shade400),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(OrderStatus status) {
    Color color;
    String label;
    switch (status) {
      case OrderStatus.scheduled:
        color = Colors.orange;
        label = 'Agendado';
        break;
      case OrderStatus.pickedUp:
        color = Colors.blue;
        label = 'Recolhido';
        break;
      case OrderStatus.cleaning:
        color = Colors.purple;
        label = 'Limpando';
        break;
      case OrderStatus.ready:
        color = Colors.green;
        label = 'Pronto';
        break;
      case OrderStatus.delivered:
        color = Colors.grey;
        label = 'Entregue';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
