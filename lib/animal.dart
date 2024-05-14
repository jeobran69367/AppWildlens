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
    return const MaterialApp(
      title: 'espece App',
      home: especePage(),
    );
  }
}

class especePage extends StatefulWidget {
  const especePage({Key? key}) : super(key: key);

  @override
  _especePageState createState() => _especePageState();
}

class _especePageState extends State<especePage> {
  late Map<String, dynamic> _especeData = {}; // Initialiser à un map vide
  late String _imageUrl = ''; // Initialiser à une chaîne vide

  @override
  void initState() {
    super.initState();
    _fetchespeceData();
  }

  Future<void> _fetchespeceData() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/espece/1'));
    if (response.statusCode == 200) {
      setState(() {
        _especeData = json.decode(response.body);
        _imageUrl = _especeData['image'];
      });
    } else {
      throw Exception('Failed to fetch espece data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('espece App'),
      ),
      body: _especeData.isNotEmpty
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16.0),
          Text(
            _especeData['Espece'],
            style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          Text(_especeData['description']),
        ],
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}