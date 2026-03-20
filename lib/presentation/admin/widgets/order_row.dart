import 'package:flutter/material.dart';

/// Linhas sofisticadas para a tabela de pedidos no Dashboard
class OrderRow extends StatelessWidget {
  final String id;
  final String client;
  final String service;
  final String status;

  const OrderRow({
    super.key,
    required this.id,
    required this.client,
    required this.service,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.indigo.shade50,
          child: const Icon(Icons.receipt_long, color: Colors.indigo),
        ),
        title: Text('$id - $client', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text('Serviço: $service', style: const TextStyle(color: Colors.grey)),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.indigo.shade50,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(status, style: TextStyle(color: Colors.indigo.shade700, fontWeight: FontWeight.bold, fontSize: 12)),
        ),
      ),
    );
  }
}
