import 'package:flutter/material.dart';
import 'calculadora_page.dart';

void main() => runApp(const CalculadoraApp());

class CalculadoraApp extends StatelessWidget {
  const CalculadoraApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora Básica',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: const CalculadoraPage(),
    );
  }
}
