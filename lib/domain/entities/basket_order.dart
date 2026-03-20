// Entidade e enumerado para pedidos do Cesto de Roupas

/// Sub-entidade: linha de roupa dentro de um pedido do Cesto
class BasketItem {
  final String name;
  final int quantity;
  final int unitPrice;
  final String emoji;

  const BasketItem({
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.emoji,
  });
}

/// Representa um pedido que foi agendado e está no cesto aguardando recolha
class BasketOrder {
  final String id;
  final String serviceType;
  final bool includeIroning;
  final int total;
  final String address;
  final String scheduledDate;
  final String scheduledTime;
  final BasketStatus status;
  final List<BasketItem> items; // Roupas selecionadas no pedido

  const BasketOrder({
    required this.id,
    required this.serviceType,
    required this.includeIroning,
    required this.total,
    required this.address,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.items,
    this.status = BasketStatus.aguardandoRecolha,
  });
}

/// Estados possíveis de um pedido no cesto
enum BasketStatus {
  aguardandoRecolha,
  emLavagem,
  prontoParaEntrega,
}
