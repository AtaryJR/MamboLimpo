import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/mock_order_repository.dart';
import '../../../domain/repositories/order_repository_interface.dart';
import '../../../domain/entities/order_entity.dart';

// Provider principal para a Injeção de Dependências.
final orderRepositoryProvider = Provider<IOrderRepository>((ref) {
  return MockOrderRepository();
});

// Este provider busca de forma assíncrona todas as tarefas de um funcionário fixo.
// Usamos .family para permitir passar o ID do funcionário como argumento.
final employeeOrdersProvider = FutureProvider.family<List<OrderEntity>, String>((ref, employeeId) async {
  final repo = ref.watch(orderRepositoryProvider);
  return repo.getOrdersForEmployee(employeeId);
});
