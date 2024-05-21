import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
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
  late Map<String, dynamic> _especeData = {}; // Initialiser à un map vide
  late String _imageUrl = ''; // Initialiser à une chaîne vide

  @override
  void initState() {
    super.initState();
    // Initialisation avec des données statiques pour vérifier l'affichage
    setState(() {
      _especeData = {
        "Espece": "Nom de l'espèce statique",
        "description": "Description statique de l'espèce",
        "image": "https://via.placeholder.com/150"
      };
      _imageUrl = _especeData['image'];
    });
    _fetchEspeceData();
  }

  Future<void> _fetchEspeceData() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/espece/1'));
      if (response.statusCode == 200) {
        setState(() {
          _especeData = json.decode(response.body);
          _imageUrl = _especeData['image'];
        });
        print(_especeData); // Log des données pour vérification
      } else {
        throw Exception('Failed to fetch espece data');
      }
    } catch (error) {
      print('Erreur lors de la récupération des données depuis l\'API: $error');
      // Chargement des données depuis un fichier local en cas d'échec de l'API
      await _fetchEspeceDataFromLocal();
    }
  }

  Future<void> _fetchEspeceDataFromLocal() async {
    try {
      final String response = await rootBundle.loadString('assets/data.json');
      setState(() {
        _especeData = json.decode(response);
        _imageUrl = _especeData['image'];
      });
      print(_especeData); // Log des données pour vérification
    } catch (error) {
      print('Erreur lors de la récupération des données locales: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Espece App'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16.0),
          // Affichage de l'image locale
          Image.asset(
            'assets/images/logo_vert.png', // Remplacez par le nom de votre image locale
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 16.0),
          _especeData.isNotEmpty
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _especeData['Espece'],
                style: const TextStyle(
                    fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(_especeData['description']),
              const SizedBox(height: 16.0),
              _imageUrl.isNotEmpty
                  ? Image.network(
                _imageUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              )
                  : Container(),
            ],
          )
              : const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
