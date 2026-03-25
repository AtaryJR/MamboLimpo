import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mambolimpo/presentation/employee/views/home_employee_page.dart';
import '../../presentation/shared/views/splash_page.dart';
import '../../presentation/client/views/home_client_page.dart';
import '../../presentation/client/views/schedule_client_page.dart';
import '../../presentation/client/views/item_selection_page.dart';
import '../../presentation/client/views/basket_page.dart';
import '../../presentation/admin/views/dashboard_admin_page.dart';
import '../../domain/entities/basket_order.dart';
import '../../presentation/client/views/profile_client_page.dart';
import '../../presentation/client/views/edit_profile_page.dart';
import '../../presentation/employee/views/task_detail_page.dart';
import '../../domain/entities/order_entity.dart';

// Provider global para injetar o router (GoRouter) na raiz da aplicação
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    // A SplashPage vai servir como nossa tela "seletora de perfis" inicial
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashPage()),

      // ROTAS DA ÁREA DO CLIENTE
      GoRoute(
        path: '/client-home',
        builder: (context, state) => const HomeClientPage(),
      ),
      GoRoute(
        path: '/client-items',
        builder: (context, state) {
          final serviceType = state.extra as String? ?? 'Lavagem Normal';
          return ItemSelectionPage(serviceType: serviceType);
        },
      ),
      GoRoute(
        path: '/client-schedule',
        builder: (context, state) {
          // Recebe os dados financeiros da tela anterior
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final subtotal = extra['subtotal'] as int? ?? 0;
          final serviceType = extra['serviceType'] as String? ?? 'Lavagem Normal';
          final includeIroning = extra['includeIroning'] as bool? ?? false;
          // Adiciona a lista de itens para o resumo final (opcional, para persistência futura)
          final items = extra['items'] as List<BasketItem>? ?? [];
          
          return ScheduleClientPage(
            subtotal: subtotal,
            serviceType: serviceType,
            includeIroning: includeIroning,
            items: items,
          );
        },
      ),
      GoRoute(
        path: '/client-basket',
        builder: (context, state) => const BasketPage(),
      ),
      GoRoute(
        path: '/client-profile',
        builder: (context, state) => const ProfileClientPage(),
      ),
      GoRoute(
        path: '/client-edit-profile',
        builder: (context, state) => const EditProfilePage(),
      ),

      // ROTAS DA ÁREA DO FUNCIONÁRIO
      GoRoute(
        path: '/employee-home',
        builder: (context, state) => const HomeEmployeePage(),
      ),
      GoRoute(
        path: '/employee-task-detail',
        builder: (context, state) {
          final order = state.extra as OrderEntity;
          return TaskDetailPage(order: order);
        },
      ),

      // ROTAS DA ÁREA DO ADMIN
      GoRoute(
        path: '/admin-dashboard',
        builder: (context, state) => const DashboardAdminPage(),
      ),
    ],
  );
});
