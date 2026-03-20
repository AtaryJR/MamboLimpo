import 'package:flutter/material.dart';

/// Entidade que representa um artigo de lavanderia disponível no catálogo
class LaundryItem {
  final String name;
  final String description;
  int price;
  final IconData icon;
  final String emoji; // Emoji visual (alinhado com o Cesto)
  int quantity;

  LaundryItem({
    required this.name,
    required this.description,
    required this.price,
    required this.icon,
    required this.emoji,
    this.quantity = 0,
  });
}
