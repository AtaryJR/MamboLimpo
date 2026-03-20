import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/promo_card.dart';
import '../widgets/service_card.dart';

// Tela principal inicial para clientes: exibe o catálogo de serviços com design moderno
class HomeClientPage extends StatelessWidget {
  const HomeClientPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors
          .grey
          .shade50, // Fundo levemente cinza para destacar os cartões brancos
      // Navigation Bar Premium e Flutuante
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            elevation: 0,
            backgroundColor: Colors.white,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Colors.grey.shade400,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: 'Início',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_basket_outlined),
                label: 'Cesto',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded),
                label: 'Perfil',
              ),
            ],
            onTap: (index) {
              // Navegação da barra inferior do cliente
              if (index == 1) context.push('/client-basket');
            },
          ),
        ),
      ),

      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: CustomScrollView(
            slivers: [
              // Cabeçalho Moderno e Estendido
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 60,
                    left: 24,
                    right: 24,
                    bottom: 32,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Mambo Limpo',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.white24,
                            child: IconButton(
                              icon: const Icon(
                                Icons.notifications_outlined,
                                color: Colors.white,
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Olá, Cliente! 👋',
                        style: TextStyle(color: Colors.white70, fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'O que vamos \nlimpar hoje?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Seção de Destaques e Promoções (Ofertas Especiais)
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 24, top: 32, bottom: 16),
                      child: Text(
                        'Ofertas Especiais',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 160,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          PromoCard(
                            title: '20% OFF',
                            subtitle: 'Na limpeza de Cobertores de Inverno.',
                            color1: Colors.orange.shade400,
                            color2: Colors.deepOrange.shade600,
                            icon: Icons.ac_unit,
                          ),
                          PromoCard(
                            title: 'Indique & Ganhe',
                            subtitle:
                                '1.500 Kz de bônus por cada amigo indicado.',
                            color1: Colors.indigo.shade400,
                            color2: Colors.indigo.shade700,
                            icon: Icons.loyalty,
                          ),
                          PromoCard(
                            title: 'Assinaturas',
                            subtitle: 'Planos mensais com frete grátis.',
                            color1: Colors.teal.shade400,
                            color2: Colors.teal.shade700,
                            icon: Icons.card_giftcard,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Seção do Catálogo de Serviços
              SliverPadding(
                padding: const EdgeInsets.only(
                  top: 32.0,
                  left: 24.0,
                  right: 24.0,
                  bottom: 24.0,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const Text(
                      'Catálogo de Serviços',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ServiceCard(
                      title: 'Lavagem Normal',
                      description:
                          'Lavagem completa com água e sabão ecológico. Retiramos as nódoas básicas.',
                      icon: Icons.local_laundry_service,
                      price: '1.500 Kz / kg',
                      onSchedulePressed: () => context.push('/client-items', extra: 'Lavagem Normal'),
                    ),
                    const SizedBox(height: 16),
                    ServiceCard(
                      title: 'Lavagem a Seco',
                      description:
                          'Ideal para tecidos delicados, vestidos e ternos. Limpeza rigorosa.',
                      icon: Icons.dry_cleaning,
                      price: '2.500 Kz / peça',
                      onSchedulePressed: () => context.push('/client-items', extra: 'Lavagem a Seco'),
                    ),
                    const SizedBox(height: 16),
                    ServiceCard(
                      title: 'Passar',
                      description:
                          'Deixamos suas roupas prontas para uso, perfeitamente vincadas.',
                      icon: Icons.iron,
                      price: '800 Kz / peça',
                      onSchedulePressed: () => context.push('/client-items', extra: 'Passar'),
                    ),
                    // Espaço extra no final para que a NavBar flutuante não cubra o último cartão
                    const SizedBox(height: 80),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
