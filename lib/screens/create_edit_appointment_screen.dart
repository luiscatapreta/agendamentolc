import 'package:flutter/material.dart';
import '../models/appointment.dart';
import '../services/firestore_service.dart';

class CreateEditAppointmentScreen extends StatefulWidget {
  final String userId;
  final Appointment? appointment;

  const CreateEditAppointmentScreen({required this.userId, this.appointment, super.key});

  @override
  State<CreateEditAppointmentScreen> createState() => _CreateEditAppointmentScreenState();
}

class _CreateEditAppointmentScreenState extends State<CreateEditAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fs = FirestoreService();

  late TextEditingController titleController;
  late TextEditingController descController;
  late TextEditingController valueController;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.appointment?.title ?? '');
    descController = TextEditingController(text: widget.appointment?.description ?? '');
    valueController = TextEditingController(text: widget.appointment?.value.toString() ?? '');
    selectedDate = widget.appointment?.startAt ?? DateTime.now();
  }

  void saveAppointment() async {
    if (!_formKey.currentState!.validate() || selectedDate == null) return;

    final a = Appointment(
      id: widget.appointment?.id,
      userId: widget.userId,
      title: titleController.text,
      description: descController.text,
      startAt: selectedDate!,
      value: double.tryParse(valueController.text) ?? 0,
    );

    if (widget.appointment == null) {
      await _fs.addAppointment(a);
    } else {
      await _fs.updateAppointment(a);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.appointment == null ? 'Novo Agendamento' : 'Editar Agendamento')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (v) => v!.isEmpty ? 'Digite o título' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Descrição'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: valueController,
                decoration: const InputDecoration(labelText: 'Valor (R\$)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(selectedDate != null
                    ? 'Data: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year} ${selectedDate!.hour}:${selectedDate!.minute}'
                    : 'Selecionar Data'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100));
                  if (date != null) {
                    final time = await showTimePicker(
                        context: context, initialTime: TimeOfDay.fromDateTime(selectedDate!));
                    if (time != null) {
                      setState(() {
                        selectedDate = DateTime(
                            date.year, date.month, date.day, time.hour, time.minute);
                      });
                    }
                  }
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: saveAppointment, child: const Text('Salvar')),
            ],
          ),
        ),
      ),
    );
  }
}
