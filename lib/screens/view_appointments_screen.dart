import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/firestore_service.dart';
import '../models/appointment.dart';
import 'create_edit_appointment_screen.dart';

class ViewAppointmentsScreen extends StatelessWidget {
  const ViewAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _fs = FirestoreService();

    return Scaffold(
      appBar: AppBar(title: const Text('Visualizar Agendamentos')),
      body: StreamBuilder<List<Appointment>>(
        stream: _fs.streamAllAppointments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final items = snapshot.data!;
          if (items.isEmpty) return const Center(child: Text('Nenhum agendamento encontrado'));

          // Agrupar por mês
          final Map<String, List<Appointment>> grupos = {};
          for (var a in items) {
            final chave = DateFormat('MM/yyyy').format(a.startAt);
            grupos.putIfAbsent(chave, () => []);
            grupos[chave]!.add(a);
          }

          return ListView(
            children: grupos.entries.map((grupo) {
              return ExpansionTile(
                title: Text('📅 ${grupo.key}'),
                children: grupo.value.map((a) {
                  return ListTile(
                    title: Text(a.title),
                    subtitle: Text(a.description),
                    leading: Text(DateFormat('dd/MM/yyyy').format(a.startAt)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('R\$ ${a.value.toStringAsFixed(2)}'),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CreateEditAppointmentScreen(
                                  userId: a.userId,
                                  appointment: a,
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await _fs.deleteAppointment(a.id!);
                          },
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
