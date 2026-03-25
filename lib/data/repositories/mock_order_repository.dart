import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository_interface.dart';

// Repositório Fake (Mock) que guarda os dados em memória enquanto não temos API Backend.
// Muito útil para apresentar o MVP e validar o fluxo UI/UX rapidamente.
class MockOrderRepository implements IOrderRepository {
  // Dados estáticos a nível de classe (Singletons fake) guardados na RAM do telefone.
  final List<OrderEntity> _mockOrders = [
    OrderEntity(
      id: 'ORD-001',
      clientId: 'CLI-123',
      employeeId: 'EMP-999', // Funcionário fake para testes
      serviceName: 'Lavagem Normal',
      pickupAddress: 'Rua das Pedras, 123',
      scheduledDate: DateTime.now().add(const Duration(hours: 1)),
      totalAmount: 25.0,
      status: OrderStatus.scheduled,
    ),
    OrderEntity(
      id: 'ORD-002',
      clientId: 'CLI-456',
      employeeId: 'EMP-999',
      serviceName: 'Passadoria',
      pickupAddress: 'Avenida de Luanda, 400',
      scheduledDate: DateTime.now().add(const Duration(hours: 3)),
      totalAmount: 15.0,
      status: OrderStatus.scheduled,
    ),
    // Novo: Mais uma recolha para hoje
    OrderEntity(
      id: 'ORD-003',
      clientId: 'CLI-789',
      employeeId: 'EMP-999',
      serviceName: 'Lavagem a Seco',
      pickupAddress: 'Bairro Operário, Bloco B, Apt 12',
      scheduledDate: DateTime.now().add(const Duration(hours: 5)),
      totalAmount: 45.0,
      status: OrderStatus.scheduled,
    ),
    // Pedidos Prontos para Entrega
    OrderEntity(
      id: 'ORD-004',
      clientId: 'CLI-101',
      employeeId: 'EMP-999',
      serviceName: 'Serviço Express',
      pickupAddress: 'Talatona, Condomínio Girassol',
      scheduledDate: DateTime.now().subtract(const Duration(hours: 2)),
      totalAmount: 60.0,
      status: OrderStatus.ready, // Pronto para ser entregue!
    ),
    OrderEntity(
      id: 'ORD-005',
      clientId: 'CLI-202',
      employeeId: 'EMP-999',
      serviceName: 'Lavagem + Engomagem',
      pickupAddress: 'Viana, Estalagem, Rua 4',
      scheduledDate: DateTime.now().subtract(const Duration(hours: 1)),
      totalAmount: 35.0,
      status: OrderStatus.ready,
    ),
    // Pedidos já Concluídos (para a aba de Histórico)
    OrderEntity(
      id: 'ORD-006',
      clientId: 'CLI-303',
      employeeId: 'EMP-999',
      serviceName: 'Lavagem Normal',
      pickupAddress: 'Samba, Estrada Direita',
      scheduledDate: DateTime.now().subtract(const Duration(days: 1)),
      totalAmount: 25.0,
      status: OrderStatus.delivered,
    ),
  ];

  @override
  Future<List<OrderEntity>> getOrdersByClient(String clientId) async {
    await Future.delayed(const Duration(seconds: 1)); // Simula tempo de carregamento da internet
    return _mockOrders.where((order) => order.clientId == clientId).toList();
  }

  @override
  Future<List<OrderEntity>> getOrdersForEmployee(String employeeId) async {
    await Future.delayed(const Duration(seconds: 1));
    return _mockOrders.where((order) => order.employeeId == employeeId).toList();
  }

  @override
  Future<List<OrderEntity>> getAllOrders() async {
    await Future.delayed(const Duration(seconds: 1));
    return _mockOrders;
  }

  @override
  Future<void> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _mockOrders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      // Fazemos o update real no item via método copyWith!
      _mockOrders[index] = _mockOrders[index].copyWith(status: newStatus);
    }
  }

  @override
  Future<void> createOrder(OrderEntity order) async {
    await Future.delayed(const Duration(seconds: 1));
    _mockOrders.add(order);
  }
}
