import '../entities/order_entity.dart';

// Interface do repositório de pedidos
// Seguindo os princípios da Clean Architecture, a camada Domain não sabe SE é Firebase, API ou LocalDatabase.
abstract class IOrderRepository {
  // Retorna os pedidos feitos por um cliente específico
  Future<List<OrderEntity>> getOrdersByClient(String clientId);
  
  // Retorna os pedidos atribuídos a um entregador específico
  Future<List<OrderEntity>> getOrdersForEmployee(String employeeId);
  
  // Retorna todos os pedidos da plataforma (Uso Restrito do Admin Panel)
  Future<List<OrderEntity>> getAllOrders();
  
  // Modifica o estado de um pedido (Ex: Recolhido -> Em Lavagem)
  Future<void> updateOrderStatus(String orderId, OrderStatus newStatus);
  
  // Cadastra um novo pedido agendado pelo cliente
  Future<void> createOrder(OrderEntity order);
}
