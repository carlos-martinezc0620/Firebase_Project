import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CitasPage extends StatelessWidget {
  const CitasPage({super.key});

  Future<void> _guardarCitas(BuildContext context) async {
    final citas = [
      {
        'paciente': 'Erick Estrella',
        'motivo': 'Revisión general',
        'fecha': '2025-09-30',
      },
      {
        'paciente': 'Juan Pérez',
        'motivo': 'Dolor estomacal',
        'fecha': '2025-10-01',
      },
      {
        'paciente': 'Sofia Martinez',
        'motivo': 'Dolor de cabeza',
        'fecha': '2025-09-02',
      },
      {
        'paciente': 'Blanca Canto',
        'motivo': 'Chequeo de presión',
        'fecha': '2025-10-11',
      },
      {
        'paciente': 'Carlos Gómez',
        'motivo': 'Consulta de nutrición',
        'fecha': '2025-12-24',
      },
      {
        'paciente': 'Rosa Ramírez',
        'motivo': 'Dolor de garganta',
        'fecha': '2025-11-04',
      },
      {
        'paciente': 'Luis Castillo',
        'motivo': 'Seguimiento de enfermedad crónica',
        'fecha': '2025-09-23',
      },
      {
        'paciente': 'Carlos Hernández',
        'motivo': 'Problemas cardíacos',
        'fecha': '2025-09-19',
      },
      {
        'paciente': 'Raúl Pech',
        'motivo': 'Problemas musculares',
        'fecha': '2025-07-28',
      },
      {
        'paciente': 'Abby Sánchez',
        'motivo': 'Análisis de sangre',
        'fecha': '2025-10-14',
      },
    ];

    final db = FirebaseFirestore.instance.collection('DocApp');

    for (var cita in citas) {
      await db.add({...cita, 'creadoEn': FieldValue.serverTimestamp()});
    }

    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('10 citas guardadas ✅')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Citas Registradas')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => _guardarCitas(context),
              child: const Text('Guardar 10 citas demo'),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('DocApp')
                  .orderBy('creadoEn', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No hay citas registradas'));
                }

                final citas = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: citas.length,
                  itemBuilder: (context, index) {
                    final cita = citas[index].data() as Map<String, dynamic>;
                    final paciente = cita['paciente'] ?? 'Desconocido';
                    final motivo = cita['motivo'] ?? 'N/A';
                    final fecha = cita['fecha'] ?? 'Sin fecha';

                    return ListTile(
                      leading: const Icon(Icons.medical_information),
                      title: Text(paciente),
                      subtitle: Text('Motivo: $motivo\nFecha: $fecha'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
