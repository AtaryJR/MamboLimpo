import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/mock_order_repository.dart';
import '../../../domain/repositories/order_repository_interface.dart';
import '../../../domain/entities/order_entity.dart';

// Provider principal para a Injeção de Dependências.
// Ele injeta a versão Mock. Futuramente para mudar para Firebase, basta mudar "MockOrderRepository" para "FirebaseOrderRepository". Nenhuma tela notará a diferença.
final orderRepositoryProvider = Provider<IOrderRepository>((ref) {
  return MockOrderRepository();
});

// Este provider busca de forma assíncrona todas as tarefas de um funcionário fixo (ex: EMP-999)
final employeeOrdersProvider = FutureProvider<List<OrderEntity>>((ref) async {
  final repo = ref.watch(orderRepositoryProvider);
  return repo.getOrdersForEmployee('EMP-999');
});
