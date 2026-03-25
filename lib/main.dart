import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // Delegados de localização
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart'; // Para inicializar datas em PT
import 'core/routes/app_router.dart';

// Ponto de entrada principal do aplicativo
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializa a formatação de datas para Português
  await initializeDateFormatting('pt_BR', null);

  runApp(
    // ProviderScope é necessário na raiz do app para o Riverpod fornecer o estado global
    const ProviderScope(
      child: MamboLimpoApp(),
    ),
  );
}

// Widget principal que define configurações estruturais da aplicação
class MamboLimpoApp extends ConsumerWidget {
  const MamboLimpoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escuta e obtém as configurações do GoRouter através do nosso provider
    final goRouter = ref.watch(appRouterProvider);

    // MaterialApp.router é usado devido a pacotes de roteamento avançados (como GoRouter)
    return MaterialApp.router(
      title: 'Mambo Limpo',
      debugShowCheckedModeBanner: false,
      // Definição do tema global inspirado no design conceitual (Material 3)
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF03A9F4), // Azul Claro: Cor de confiança principal
          primary: const Color(0xFF03A9F4), // Azul Claro
          secondary: const Color(0xFF81C784), // Verde Suave: Ações positivas (Agendar, Pronto)
          surface: Colors.white, // Branco da limpeza
        ),
        useMaterial3: true,
      ),
      // Configuração extraída do GoRouter
      routerConfig: goRouter,
      
      // --- Configurações de Localização (Português) ---
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'), // Português Brasil
        Locale('pt', 'PT'), // Português Portugal
      ],
      locale: const Locale('pt', 'BR'), // Define PT-BR como padrão
    );
  }
}
