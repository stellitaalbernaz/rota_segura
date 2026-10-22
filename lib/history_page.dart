import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Viagens'),
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.check_circle, color: Colors.green),
            title: Text('Viagem: Centro -> Aeroporto'),
            subtitle: Text('06/02/2026 - R\$ 45,00'),
          ),
          ListTile(
            leading: Icon(Icons.check_circle, color: Colors.green),
            title: Text('Viagem: Vila Nova -> Shopping'),
            subtitle: Text('06/02/2026 - R\$ 18,50'),
          ),
        ],
      ),
    );
  }
}