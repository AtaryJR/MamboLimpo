import 'package:flutter/material.dart';
import '../../domain/entities/laundry_item.dart';

/// Catálogo mockado de artigos disponíveis para lavagem — alinhado com os emojis do Cesto
List<LaundryItem> getMockLaundryItems() {
  return [
    // --- Parte Superior ---
    LaundryItem(
      name: 'Camisa / T-Shirt',
      description: 'Lavagem normal e engomar a vapor',
      price: 800,
      icon: Icons.checkroom,
      emoji: '👕',
    ),
    LaundryItem(
      name: 'Camisa Social',
      description: 'Lavagem delicada com amido',
      price: 1000,
      icon: Icons.checkroom,
      emoji: '👔',
    ),
    LaundryItem(
      name: 'Casaco / Blusão',
      description: 'Lavagem a frio e secagem suave',
      price: 2200,
      icon: Icons.dry_cleaning,
      emoji: '🧥',
    ),
    LaundryItem(
      name: 'Suéter / Malha',
      description: 'Lavagem delicada para lãs',
      price: 1500,
      icon: Icons.dry_cleaning,
      emoji: '🧶',
    ),

    // --- Parte Inferior ---
    LaundryItem(
      name: 'Calça Jeans',
      description: 'Lavagem profunda e secagem',
      price: 1200,
      icon: Icons.straighten,
      emoji: '👖',
    ),
    LaundryItem(
      name: 'Calça Dress / Social',
      description: 'Lavagem e engomagem social',
      price: 1400,
      icon: Icons.straighten,
      emoji: '👖',
    ),
    LaundryItem(
      name: 'Shorts / Bermuda',
      description: 'Lavagem rápida e secagem ao sol',
      price: 700,
      icon: Icons.straighten,
      emoji: '🩳',
    ),

    // --- Vestimentas Inteiras ---
    LaundryItem(
      name: 'Vestido Simples',
      description: 'Lavagem delicada a frio',
      price: 2000,
      icon: Icons.woman,
      emoji: '👗',
    ),
    LaundryItem(
      name: 'Vestido de Festa',
      description: 'Lavagem a seco com cuidado especial',
      price: 4000,
      icon: Icons.woman,
      emoji: '👗',
    ),
    LaundryItem(
      name: 'Fato / Terno Completo',
      description: 'Lavagem a seco premium e engoma',
      price: 5000,
      icon: Icons.dry_cleaning,
      emoji: '🤵',
    ),

    // --- Roupas Íntimas e de Cama ---
    LaundryItem(
      name: 'Cueca / Calcinha',
      description: 'Lavagem higiénica a 60°C',
      price: 350,
      icon: Icons.self_improvement,
      emoji: '🩲',
    ),
    LaundryItem(
      name: 'Meia / Soquete',
      description: 'Lavagem higiénica em lote',
      price: 200,
      icon: Icons.airline_seat_legroom_normal,
      emoji: '🧦',
    ),

    // --- Ropa de Casa ---
    LaundryItem(
      name: 'Toalha de Banho',
      description: 'Lavagem de alta temperatura',
      price: 600,
      icon: Icons.water,
      emoji: '🛁',
    ),
    LaundryItem(
      name: 'Lençol de Cama',
      description: 'Lavagem com amaciador incluído',
      price: 1800,
      icon: Icons.bed,
      emoji: '🛏️',
    ),
    LaundryItem(
      name: 'Fronha de Almofada',
      description: 'Lavagem suave antialérgica',
      price: 700,
      icon: Icons.bed,
      emoji: '💤',
    ),
    LaundryItem(
      name: 'Cobertor / Edredão',
      description: 'Lavagem de alta voltagem',
      price: 4500,
      icon: Icons.king_bed,
      emoji: '🛌',
    ),
    LaundryItem(
      name: 'Cortina / Renda',
      description: 'Lavagem delicada com suspensão',
      price: 3500,
      icon: Icons.window,
      emoji: '🪟',
    ),
  ];
}
