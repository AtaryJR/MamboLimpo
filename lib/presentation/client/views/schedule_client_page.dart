import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../../../domain/entities/basket_order.dart';
import '../providers/basket_provider.dart';
import '../providers/address_provider.dart';

// Tela de Agendamento de Serviço: recebe o resumo financeiro do cesto e permite cupons
class ScheduleClientPage extends ConsumerStatefulWidget {
  final int subtotal;
  final String serviceType;
  final bool includeIroning;
  final List<BasketItem> items;

  const ScheduleClientPage({
    super.key,
    required this.subtotal,
    required this.serviceType,
    required this.includeIroning,
    required this.items,
  });

  @override
  ConsumerState<ScheduleClientPage> createState() => _ScheduleClientPageState();
}

class _ScheduleClientPageState extends ConsumerState<ScheduleClientPage> {
  final TextEditingController _couponController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay selectedTime = const TimeOfDay(hour: 10, minute: 0);

  // Percentagem de desconto aplicada ao cupom (0 a 100)
  double discountPercent = 0;
  String couponMessage = '';
  bool couponApplied = false;

  // Estados para endereço
  bool isStorePickup = false;
  List<dynamic> _addressSuggestions = [];
  bool _isLoadingLocation = false;
  bool _showSuggestions = false;

  // Lista de Cupons Válidos (simulados/mock)
  final Map<String, double> validCoupons = {
    'MAMBO10': 10,
    'LIMPO20': 20,
    'PROMO50': 50,
  };

  // Total após o desconto do cupom
  int get totalFinal {
    if (discountPercent == 0) return widget.subtotal;
    return (widget.subtotal * (1 - discountPercent / 100)).round();
  }

  // Desconto em Kz
  int get discountAmount => widget.subtotal - totalFinal;

  // Tenta aplicar o cupom digitado pelo usuário
  void _applyCoupon() {
    final code = _couponController.text.trim().toUpperCase();
    if (validCoupons.containsKey(code)) {
      setState(() {
        discountPercent = validCoupons[code]!;
        couponMessage =
            'Cupom aplicado! ${discountPercent.toInt()}% de desconto';
        couponApplied = true;
      });
    }
  }

  // Função para abrir o seletor de data
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // Função para abrir o seletor de hora
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  // Função para obter localização via GPS
  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Por favor, ative os serviços de localização.'),
            ),
          );
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Permissão de localização negada.')),
            );
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'As permissões de localização estão permanentemente negadas. Ative-as nas configurações.',
              ),
            ),
          );
        }
        return;
      }

      final position = await Geolocator.getCurrentPosition();

      // Reverse Geocoding via Nominatim (Gratuito)
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=${position.latitude}&lon=${position.longitude}&zoom=18&addressdetails=1',
      );

      final response = await http.get(
        url,
        headers: {'User-Agent': 'MamboLimpoApp'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _addressController.text = data['display_name'] ?? '';
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao obter localização: $e')),
        );
      }
    } finally {
      setState(() => _isLoadingLocation = false);
    }
  }

  // Função para pesquisar endereços (Autocomplete)
  Future<void> _searchAddress(String query) async {
    if (query.length < 3) {
      setState(() {
        _addressSuggestions = [];
        _showSuggestions = false;
      });
      return;
    }

    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1&limit=5',
      );
      final response = await http.get(
        url,
        headers: {'User-Agent': 'MamboLimpoApp'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _addressSuggestions = data;
          _showSuggestions = true;
        });
      }
    } catch (e) {
      debugPrint('Erro na pesquisa: $e');
    }
  }

  @override
  void dispose() {
    _couponController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // Abre diálogo para guardar endereço
  void _showSaveAddressDialog(String address) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Guardar Endereço'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Rótulo (ex: Casa, Trabalho)',
            hintText: 'Digite um nome para este local',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                ref
                    .read(addressProvider.notifier)
                    .addAddress(controller.text, address);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Endereço guardado com sucesso!'),
                  ),
                );
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final savedAddresses = ref.watch(addressProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: CustomScrollView(
              slivers: [
                // Cabeçalho Premium com título centralizado
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
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ),
                            const Text(
                              'Agendar Recolha',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Escolha onde e quando devemos buscar\no seu cesto de roupas.',
                          style: TextStyle(color: Colors.white70, fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                // Formulário de Agendamento
                SliverPadding(
                  padding: const EdgeInsets.all(24.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // --- Serviço Selecionado no Topo ---
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.07),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.local_laundry_service,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.serviceType,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                ),
                                if (widget.includeIroning)
                                  const Text(
                                    '+ Engomadoria',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // --- Detalhes da Recolha ---
                      const Text(
                        'Detalhes da Recolha',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Toggle: Recolha no Balcão
                      SwitchListTile(
                        title: const Text('Entregar no Balcão'),
                        subtitle: const Text(
                          'Eu levarei as roupas à lavandaria',
                        ),
                        value: isStorePickup,
                        onChanged: (val) {
                          setState(() {
                            isStorePickup = val;
                            if (val) {
                              _addressController.clear();
                              _showSuggestions = false;
                            }
                          });
                        },
                        secondary: Icon(
                          Icons.storefront,
                          color: isStorePickup
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),

                      if (!isStorePickup) ...[
                        const SizedBox(height: 16),
                        // Atalhos de Morada (Dinâmicos)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              ...savedAddresses.map(
                                (saved) => Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: ActionChip(
                                    avatar: const Icon(
                                      Icons.bookmark_outline,
                                      size: 16,
                                    ),
                                    label: Text(saved.label),
                                    onPressed: () {
                                      setState(() {
                                        _addressController.text = saved.address;
                                        _showSuggestions = false;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              ActionChip(
                                avatar: const Icon(Icons.add, size: 16),
                                label: const Text('Guardar Atual'),
                                onPressed: () {
                                  if (_addressController.text.isNotEmpty) {
                                    _showSaveAddressDialog(
                                      _addressController.text,
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Por favor, introduza uma morada primeiro',
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Campo Endereço
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _addressController,
                            onChanged: _searchAddress,
                            decoration: InputDecoration(
                              labelText: 'Endereço de Recolha',
                              prefixIcon: Icon(
                                Icons.location_on,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              suffixIcon: IconButton(
                                icon: _isLoadingLocation
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Icon(
                                        Icons.my_location,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                onPressed: _isLoadingLocation
                                    ? null
                                    : _getCurrentLocation,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),

                        // Lista de Sugestões (Autocomplete)
                        if (_showSuggestions && _addressSuggestions.isNotEmpty)
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Column(
                              children: _addressSuggestions.map((suggestion) {
                                return ListTile(
                                  leading: const Icon(
                                    Icons.history_edu,
                                    size: 18,
                                  ),
                                  title: Text(
                                    suggestion['display_name'],
                                    style: const TextStyle(fontSize: 13),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _addressController.text =
                                          suggestion['display_name'];
                                      _showSuggestions = false;
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                      ],
                      const SizedBox(height: 24),

                      // Seleção de Data e Hora
                      const Text(
                        'Data e Hora',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TimePickerButton(
                              icon: Icons.calendar_today,
                              label: DateFormat(
                                'dd MMM yyyy',
                                'pt_BR',
                              ).format(selectedDate),
                              onPressed: () => _selectDate(context),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TimePickerButton(
                              icon: Icons.access_time,
                              label: selectedTime.format(context),
                              onPressed: () => _selectTime(context),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // --- Secção de Cupom de Desconto ---
                      const Text(
                        'Cupom de Desconto',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: _couponController,
                                textCapitalization:
                                    TextCapitalization.characters,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Ex: MAMBO10',
                                  prefixIcon: Icon(
                                    Icons.confirmation_num_outlined,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: _applyCoupon,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 18,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Aplicar',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Mensagem de resultado do cupom
                      if (couponMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 4.0),
                          child: Text(
                            couponMessage,
                            style: TextStyle(
                              color: couponApplied
                                  ? Colors.green.shade600
                                  : Colors.red.shade400,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      const SizedBox(height: 32),

                      // --- Cartão Resumo do Cesto ---
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Título do resumo
                            Row(
                              children: [
                                Icon(
                                  Icons.shopping_basket_outlined,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Resumo do Cesto',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Subtotal
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Subtotal:',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  '${widget.subtotal} Kz',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            // Linha de desconto (aparece só quando cupom aplicado)
                            if (couponApplied) ...[
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Desconto (${discountPercent.toInt()}%):',
                                    style: TextStyle(
                                      color: Colors.green.shade600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    '- $discountAmount Kz',
                                    style: TextStyle(
                                      color: Colors.green.shade600,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.0),
                              child: Divider(),
                            ),
                            // Total Final
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total a Pagar:',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '$totalFinal Kz',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Botão de Confirmação do Agendamento
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          icon: const Icon(
                            Icons.shopping_basket,
                            color: Colors.white,
                            size: 20,
                          ),
                          label: const Text(
                            'Confirmar',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            final newOrder = BasketOrder(
                              id: '#ML-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                              serviceType: widget.serviceType,
                              includeIroning: widget.includeIroning,
                              items: widget.items,
                              total: totalFinal,
                              address: isStorePickup
                                  ? 'Recolha no balcão'
                                  : (_addressController.text.isEmpty
                                        ? 'Recolha no balcão'
                                        : _addressController.text),
                              scheduledDate: DateFormat(
                                'dd MMM yyyy',
                                'pt_BR',
                              ).format(selectedDate),
                              scheduledTime: selectedTime.format(context),
                              status: BasketStatus.aguardandoRecolha,
                            );

                            ref
                                .read(basketProvider.notifier)
                                .addOrder(newOrder);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  '✅ As roupas aguardam recolha!',
                                ),
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.primary,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                            // Abre o Cesto de Roupas para o cliente acompanhar o pedido
                            Future.delayed(
                              const Duration(milliseconds: 800),
                              () {
                                if (context.mounted) {
                                  context.go('/client-basket');
                                }
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.secondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widget auxiliar para botões de seleção de tempo
class TimePickerButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const TimePickerButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 16.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(height: 8),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
