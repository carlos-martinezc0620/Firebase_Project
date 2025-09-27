import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/confirmation_bloc.dart';
import '../bloc/confirmation_event.dart';
import '../bloc/confirmation_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentDetailPage extends StatefulWidget {
  final String userId;
  final String appointmentId;

  const AppointmentDetailPage({
    super.key,
    required this.userId,
    required this.appointmentId,
  });

  @override
  State<AppointmentDetailPage> createState() => _AppointmentDetailPageState();
}

class _AppointmentDetailPageState extends State<AppointmentDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final _ctrlPaciente = TextEditingController();
  final _ctrlMotivo = TextEditingController();
  DateTime? _fecha;

  @override
  void dispose() {
    _ctrlPaciente.dispose();
    _ctrlMotivo.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final hoy = DateTime.now();
    final f = await showDatePicker(
      context: context,
      firstDate: DateTime(hoy.year - 1),
      lastDate: DateTime(hoy.year + 2),
      initialDate: _fecha ?? hoy,
    );

    if (f != null) setState(() => _fecha = f);
  }

  Future<void> _guardarCita(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    // Guardar los datos en Firestore
    await FirebaseFirestore.instance.collection('confirmations').add({
      'userId': widget.userId,
      'appointmentId': widget.appointmentId,
      'paciente': _ctrlPaciente.text.trim(),
      'motivo': _ctrlMotivo.text.trim(),
      'fecha': _fecha ?? DateTime.now(),
      'timestamp': FieldValue.serverTimestamp(),
    });

    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Confirmación enviada ✅')));
    }

    _formKey.currentState!.reset();
    setState(() => _fecha = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirmar cita')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocProvider(
          create: (_) => ConfirmationBloc(),
          child: BlocConsumer<ConfirmationBloc, ConfirmationState>(
            listener: (context, state) {
              if (state is ConfirmationSent) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Confirmación enviada ✅')),
                );
              }
            },
            builder: (context, state) {
              return Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _ctrlPaciente,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del paciente',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _ctrlMotivo,
                      decoration: const InputDecoration(
                        labelText: 'Motivo de la cita',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: _pickDate,
                      child: Text(
                        _fecha == null
                            ? 'Elegir fecha'
                            : 'Fecha: ${_fecha!.toLocal().toString().split(' ').first}',
                      ),
                    ),
                    const SizedBox(height: 16),
                    state is ConfirmationSending
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: () {
                              context.read<ConfirmationBloc>().add(
                                SendConfirmationEvent(
                                  userId: widget.userId,
                                  appointmentId: widget.appointmentId,
                                ),
                              );
                              _guardarCita(context);
                            },
                            child: const Text('Guardar cita'),
                          ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
