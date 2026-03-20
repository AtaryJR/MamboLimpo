import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/laundry_item.dart';
import '../../../core/constants/mock_laundry_items.dart';
import '../widgets/laundry_item_card.dart';

// Página de Seleção de Peças de Roupa
class ItemSelectionPage extends StatefulWidget {
  final String serviceType;
  const ItemSelectionPage({super.key, required this.serviceType});

  @override
  State<ItemSelectionPage> createState() => _ItemSelectionPageState();
}

class _ItemSelectionPageState extends State<ItemSelectionPage> {
  // Inicialização da lista de itens usando o arquivo mock externo
  late final List<LaundryItem> items;
  bool includeIroning = false;

  @override
  void initState() {
    super.initState();
    // Carrega os dados mockados limpos ao abrir a página
    items = getMockLaundryItems();
  }

  int _calculateItemPrice(int basePrice) {
    double multiplier = 1.0;

    // Regra base do serviço ativo
    if (widget.serviceType == 'Lavagem a Seco') {
      multiplier = 1.5;
    } else if (widget.serviceType == 'Passar') {
      multiplier = 0.5;
    }

    // Se o serviço NÃO for Passar, e o usuário quiser engomar + lavar:
    if (widget.serviceType != 'Passar' && includeIroning) {
      multiplier += 0.5; // Incrementa 50% do valor da peça
    }

    return (basePrice * multiplier).round();
  }

  // Calcula o total em tempo real sempre que a quantidade muda
  int get subtotal {
    return items.fold(
      0,
      (total, item) =>
          total + (_calculateItemPrice(item.price) * item.quantity),
    );
  }

  // Incrementa a quantidade de um item
  void _increment(int index) {
    setState(() {
      items[index].quantity++;
    });
  }

  // Decrementa a quantidade de um item (mínimo 0)
  void _decrement(int index) {
    setState(() {
      if (items[index].quantity > 0) {
        items[index].quantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50, // Cor de fundo padrão Premium
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 800,
          ), // Evita expansão horizontal excessiva
          child: CustomScrollView(
            slivers: [
              // Cabeçalho da página com gradiente
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 60,
                    left: 16,
                    right: 16,
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
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                              onPressed: () => Navigator.of(
                                context,
                              ).pop(), // Volta para a tela principal
                            ),
                          ),
                          Text(
                            widget.serviceType,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Adicione a quantidade de peças para \neste serviço de agendamento.',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              // Switch de Serviço Adicional: "Passar Roupa" (Se aplicável)
              SliverToBoxAdapter(
                child: widget.serviceType != 'Passar'
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 8.0,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.2),
                            ),
                          ),
                          child: SwitchListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            title: Text(
                              'Adicionar Engomadoria',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            subtitle: const Text(
                              'Serviço extra de engomar (+50% de custo)',
                              style: TextStyle(fontSize: 12),
                            ),
                            activeTrackColor: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.5),
                            activeColor: Theme.of(context).colorScheme.primary,
                            value: includeIroning,
                            onChanged: (bool value) {
                              setState(() {
                                includeIroning = value;
                              });
                            },
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),

              // Lista de Items com contadores (+ / -)
              SliverPadding(
                padding: const EdgeInsets.all(24.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final item = items[index];
                    return LaundryItemCard(
                      name: item.name,
                      description: item.description,
                      price: _calculateItemPrice(item.price), // Preço já computado
                      icon: item.icon,
                      emoji: item.emoji, // Emoji coerente com o Cesto
                      quantity: item.quantity,
                      onIncrement: () => _increment(index),
                      onDecrement: () => _decrement(index),
                      onQuantityChanged: (newQty) {
                        setState(() {
                          items[index].quantity = newQty;
                        });
                      },
                    );
                  }, childCount: items.length),
                ),
              ),

              // Espaçador para o Bottom Barra
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),

      // Bottom Sheet flutuante contendo o Subtotal e Botão Avançar
      bottomSheet: Container(
        color: Colors.grey.shade50,
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: 0.08,
                  ), // Sombra superior invertida
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Estimado:',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '$subtotal Kz', // Total renderizado em KwaNzas
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: subtotal > 0
                          ? () {
                              // Passa o resumo financeiro e o serviço para o próximo ecrã
                              context.push('/client-schedule', extra: {
                                'subtotal': subtotal,
                                'serviceType': widget.serviceType,
                                'includeIroning': includeIroning,
                              });
                            }
                          : null, // Desabilita o botão se o cesto estiver vazio
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        disabledBackgroundColor: Colors.grey.shade300,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Ir para Agendamento',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
