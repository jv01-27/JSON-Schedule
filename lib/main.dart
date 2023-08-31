// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Horario Escolar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<Map<String, dynamic>> _loadHorarioAsset() async {
    String jsonString = await rootBundle.loadString('assets/horario.json');
    return json.decode(jsonString);
  }

  List<Map<String, String>> _getDayData(
      String day, Map<String, dynamic> jsonData) {
    List<Map<String, dynamic>> horarioData =
        List<Map<String, dynamic>>.from(jsonData['horario']);
    return horarioData
        .where((item) => item[day] != null)
        .toList()
        .cast<Map<String, String>>();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Horario Escolar'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Lunes'),
              Tab(text: 'Martes'),
              Tab(text: 'Miércoles'),
              Tab(text: 'Jueves'),
              Tab(text: 'Viernes'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildHorarioTab('Lunes'),
            _buildHorarioTab('Martes'),
            _buildHorarioTab('Miércoles'),
            _buildHorarioTab('Jueves'),
            _buildHorarioTab('Viernes'),
          ],
        ),
      ),
    );
  }

  Widget _buildHorarioTab(String day) {
  return FutureBuilder<Map<String, dynamic>>(
    future: _loadHorarioAsset(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return const Text('Error al cargar los datos');
      } else if (!snapshot.hasData) {
        return const Text('No hay datos disponibles');
      } else {
        List<Map<String, dynamic>> horarioData = List<Map<String, dynamic>>.from(snapshot.data!['horario']);
        List<Map<String, dynamic>> dayData = horarioData.where((item) => item[day] != null).toList();

        return ListView.builder(
          itemCount: dayData.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(dayData[index][day]),
              //subtitle: Text('Aula: ${dayData[index]['aula $day']}'),
              subtitle: Text(dayData[index]['Horario']),
            );
          },
        );
      }
    },
  );
}

}
