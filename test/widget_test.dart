// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imag/main.dart';

import 'package:untitled2/main.dart';

void main() {
  testWidgets('MyApp widget test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(
      camera: CameraDescription(
        name: 'fake',
        lensDirection: CameraLensDirection.front,
        sensorOrientation: 0, // Remplacez 0 par une valeur appropriée si nécessaire
      ),
    ));

    // Your test logic goes here...

    // For example, you can verify the existence of certain widgets.
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(HomePage), findsOneWidget);

    // Or you can verify the presence of certain text.
    expect(find.text('Accueil'), findsOneWidget);
  });
}
