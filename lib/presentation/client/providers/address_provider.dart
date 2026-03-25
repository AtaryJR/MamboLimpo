import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Modelo simples para um endereço guardado
class SavedAddress {
  final String label;
  final String address;

  SavedAddress({required this.label, required this.address});
}

/// Controller para gerir a lista de endereços guardados do cliente
class AddressNotifier extends Notifier<List<SavedAddress>> {
  @override
  List<SavedAddress> build() {
    // Endereços iniciais (Mocks)
    return [
      SavedAddress(label: 'Casa', address: 'Residência Principal, Luanda'),
      SavedAddress(label: 'Trabalho', address: 'Edifício Kaluanda, Piso 4'),
    ];
  }

  void addAddress(String label, String address) {
    // Evita duplicados com o mesmo rótulo
    state = [
      ...state.where((a) => a.label != label),
      SavedAddress(label: label, address: address),
    ];
  }

  void removeAddress(String label) {
    state = state.where((a) => a.label != label).toList();
  }
}

final addressProvider = NotifierProvider<AddressNotifier, List<SavedAddress>>(AddressNotifier.new);
