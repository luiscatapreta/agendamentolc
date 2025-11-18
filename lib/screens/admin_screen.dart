import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin - Agendamentos")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("agendamentos")
            .orderBy("dia")
            .snapshots(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snap.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("Nenhum agendamento encontrado."));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (_, i) {
              final d = docs[i];
              final item = d.data() as Map<String, dynamic>;

              DateTime data;
              final campo = item['dia'];
              if (campo is Timestamp) {
                data = campo.toDate();
              } else {
                data = DateTime.tryParse(campo.toString()) ?? DateTime.now();
              }

              final dia = "${data.day}/${data.month}/${data.year}";

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(item["cliente"] ?? 'Sem título'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item["descricao"] ?? ''),
                      Text(dia),
                    ],
                  ),
                  trailing: Column(
                    children: [
                      Text("R\$ ${item['valor'] ?? 0}"),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection("agendamentos")
                              .doc(d.id)
                              .delete();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
