import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'bloc/appointment_detail_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Confirmar Cita',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const AppointmentDetailPage(
        userId: 'user123',
        appointmentId: 'appointment456',
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Citas Médicas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ), // ThemeData
      home: const _HomeContent(),
    ); // MaterialApp
  }
}

// HomePage sirve como pantalla inicial, con un botón para ir a AppointmentDetailPage
class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    // Para simplificar el mini reto, usamos datos de ejemplo
    const exampleUserId = 'user123';
    const exampleAppointmentId = 'appointment456';

    return Scaffold(
      appBar: AppBar(title: const Text('Inicio - Citas Médicas')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AppointmentDetailPage(
                  userId: exampleUserId,
                  appointmentId: exampleAppointmentId,
                ),
              ), // MaterialPageRoute
            );
          },
          child: const Text('Ir a Detalles de Cita'),
        ), // ElevatedButton
      ), // Center
    ); // Scaffold
  }
}
