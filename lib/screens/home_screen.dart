// ================= screens/home_screen.dart =================
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'create_edit_appointment_screen.dart';
import 'view_appointments_screen.dart';
import 'admin_screen.dart';

class HomeScreen extends StatelessWidget {
  final User user;
  const HomeScreen({required this.user, super.key});

  bool get isAdmin => user.email?.endsWith('@admin.com') ?? false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendamentos'),
        actions: [
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.admin_panel_settings, size: 28),
              tooltip: 'Administração',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminScreen()),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.logout, size: 28),
            tooltip: 'Sair',
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.visibility),
              label: const Text("Visualizar Agendamentos"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 60),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ViewAppointmentsScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text("Criar Novo Agendamento"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 60),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CreateEditAppointmentScreen(userId: user.uid),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
