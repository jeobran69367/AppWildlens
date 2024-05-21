import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Espece App',
      home: EspecePage(),
    );
  }
}

class EspecePage extends StatefulWidget {
  const EspecePage({Key? key}) : super(key: key);

  @override
  _EspecePageState createState() => _EspecePageState();
}

class _EspecePageState extends State<EspecePage> {
  Future<Map<String, dynamic>> _fetchEspeceData(int id) async {
    final response = await http.get(Uri.parse('http://192.168.1.100:8000/espece/$id')); // Changez l'IP ici
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch espece data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Espece App'),
      ),
      body: FutureBuilder(
        future: _fetchEspeceData(5), // Changez l'ID ici selon votre besoin
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final especeData = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      especeData['Espece'],
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      especeData['Description'],
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    // Ajoutez le reste des informations à afficher ici...
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
