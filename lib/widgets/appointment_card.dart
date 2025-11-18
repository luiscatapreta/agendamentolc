import 'package:flutter/material.dart';
import '../models/appointment.dart';
import 'package:intl/intl.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AppointmentCard({
    required this.appointment,
    this.onEdit,
    this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(appointment.startAt);
    final formattedValue = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$')
        .format(appointment.value);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(appointment.title, style: const TextStyle(fontWeight: FontWeight.bold))),
            Text(formattedValue, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(appointment.description),
            Text(formattedDate, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onEdit != null) IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: onEdit),
            if (onDelete != null) IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}
