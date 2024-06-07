import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_api/screen/screen.login.dart';
import 'package:flutter_api/trash.dart';

void main() {
  // Bloquer la rotation de l'écran avant de démarrer l'application
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MainApp());
  });
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatbot Fil Rouge',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const ScreenLogin(),
    );
  }
}

