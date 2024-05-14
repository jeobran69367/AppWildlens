import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'dart:typed_data'; // Import pour Uint8List

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(MyApp(camera: firstCamera));
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;

  const MyApp({Key? key, required this.camera}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mon Projet Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(camera: camera),
    );
  }
}

class HomePage extends StatelessWidget {
  final CameraDescription camera;

  const HomePage({Key? key, required this.camera}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                'assets/images/wildaware-high-resolution-color-logo.png',
                height: 150,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CameraPage(camera: camera),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: Text(
                'Prendre une photo',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CameraPage extends StatefulWidget {
  final CameraDescription camera;

  const CameraPage({Key? key, required this.camera}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  File? _imageFile;
  bool _isCameraActive = true;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildCameraPreview() {
    return Center(
      child: Container(
        child: AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: CameraPreview(_controller),
        ),
      ),
    );
  }

  void _onCapturePressed() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();
      final bytes = await image.readAsBytes(); // Lire l'image en tant que bytes

      setState(() {
        _imageFile = File(image.path);
        _isCameraActive = false;
      });

      // Afficher la page de prévisualisation avec les options
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PreviewPage(imageBytes: bytes), // Passer les bytes à la page de prévisualisation
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Caméra'),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _buildCameraPreview();
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isCameraActive ? _onCapturePressed : null,
        child: Icon(Icons.camera),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class PreviewPage extends StatelessWidget {
  final Uint8List imageBytes; // Utiliser Uint8List pour les bytes d'image

  const PreviewPage({Key? key, required this.imageBytes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aperçu'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.memory(
            imageBytes,
            height: 300,
            width: 300,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Ajoutez ici la logique pour valider et stocker localement
                  Navigator.pop(context); // Revenir à la page de la caméra
                },
                child: Text('Valider'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Ajoutez ici la logique pour supprimer et reprendre une photo
                  Navigator.pop(context); // Revenir à la page de la caméra
                },
                child: Text('Supprimer'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
