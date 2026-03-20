// Estado do pedido durante o seu ciclo de vida
enum OrderStatus { scheduled, pickedUp, cleaning, ready, delivered }

// Entidade principal de domínio que representa um Pedido de Lavanderia
class OrderEntity {
  final String id;
  final String clientId;
  final String employeeId;
  final String serviceName;
  final String pickupAddress;
  final DateTime scheduledDate;
  final double totalAmount;
  final OrderStatus status;

  OrderEntity({
    required this.id,
    required this.clientId,
    required this.employeeId,
    required this.serviceName,
    required this.pickupAddress,
    required this.scheduledDate,
    required this.totalAmount,
    required this.status,
  });

  // Método utilitário comum para clonar o objeto modificando apenas propriedades necessárias
  OrderEntity copyWith({
    String? id,
    String? clientId,
    String? employeeId,
    String? serviceName,
    String? pickupAddress,
    DateTime? scheduledDate,
    double? totalAmount,
    OrderStatus? status,
  }) {
    return OrderEntity(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      employeeId: employeeId ?? this.employeeId,
      serviceName: serviceName ?? this.serviceName,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
    );
  }
}
