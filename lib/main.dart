import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'CitasPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options:
        DefaultFirebaseOptions.currentPlatform, // usa tu firebase_options.dart
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CitasPage(), // pantalla simple con el botón
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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

    final database = FirebaseFirestore.instance.collection('DocApp');

    for (var cita in citas)
      await database.add({...cita, 'creadoEn': FieldValue.serverTimestamp()});

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Se han guardado 10 citas exitosamente.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Demo Firebase')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _guardarCitas(context),
          child: const Text('Guardar cita demo'),
        ),
      ),
    );
  }
}
