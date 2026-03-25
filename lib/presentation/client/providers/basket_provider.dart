import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/basket_order.dart';

/// Notifier que gerencia a lista de pedidos no cesto do cliente
class BasketController extends Notifier<List<BasketOrder>> {
  @override
  List<BasketOrder> build() {
    // Dados mockados iniciais (anteriormente em BasketPage)
    return [
      const BasketOrder(
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
      const BasketOrder(
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
      const BasketOrder(
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
  }

  /// Adiciona um novo pedido ao cesto
  void addOrder(BasketOrder order) {
    state = [order, ...state];
  }

  /// Cancela um pedido
  void cancelOrder(String orderId) {
    state = state.where((o) => o.id != orderId).toList();
  }

  /// Atualiza o status de um pedido
  void updateStatus(String orderId, BasketStatus newStatus) {
    state = [
      for (final order in state)
        if (order.id == orderId)
          BasketOrder(
            id: order.id,
            serviceType: order.serviceType,
            includeIroning: order.includeIroning,
            total: order.total,
            address: order.address,
            scheduledDate: order.scheduledDate,
            scheduledTime: order.scheduledTime,
            items: order.items,
            status: newStatus,
          )
        else
          order,
    ];
  }
}

/// Provider global para acessar o controlador do cesto
final basketProvider = NotifierProvider<BasketController, List<BasketOrder>>(() {
  return BasketController();
});
