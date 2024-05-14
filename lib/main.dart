import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // Request camera and storage permissions on app launch
  void initState() {
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    // Request permission to access camera and storage
    await Permission.camera.request();
    await Permission.storage.request();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mon Projet Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background_image.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Bienvenue sur Application',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Image.asset(
                    'assets/images/wildaware-high-resolution-color-logo.png',
                    height: 150,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ImageCapture(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    child: const Text(
                      'Prendre une photo',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ImageCapture extends StatefulWidget {
  const ImageCapture({Key? key}) : super(key: key);

  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Reconnaissance d'Empreintes Animales",
          style: TextStyle(
            fontSize: 12,
            color: Colors.lightGreen,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(10.0),
                border: _image == null
                    ? Border.all(color: Colors.blue, width: 2.0)
                    : Border.all(color: Colors.transparent),
              ),
              child: _image == null
                  ? const Icon(
                Icons.image,
                size: 80,
                color: Colors.blue,
              )
                  : ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.file(
                  _image!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    getGallery();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: const Text("Choose from gallery"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    getCamera();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: const Text("Take from camera"),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (_image != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      getCamera();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: const Text("Retake"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Passer à l'étape suivante avec l'image sélectionnée
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NextPage(_image!),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: const Text("Good"),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Future<void> getCamera() async {
    final pickedFile = await _picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) return;

(() {
        _image = File(pickedFile!.path);
      });

  }

  Future<void> getGallery() async {
    final pickedFile = await  _picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }
}

class imageTempory {
}



class NextPage extends StatelessWidget {
  final File _image;

  const NextPage(this._image, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Next Page"),
      ),
      body: Center(
        child: Image.file(
          _image,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
