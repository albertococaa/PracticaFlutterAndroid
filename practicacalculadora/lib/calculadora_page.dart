
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculadoraPage extends StatefulWidget {
  const CalculadoraPage({super.key});
  @override
  State<CalculadoraPage> createState() => _CalculadoraPageState();
}

class _CalculadoraPageState extends State<CalculadoraPage> {
  String _expression = '';
  String _historico  = '';
  String _resultado  = '0';

  void _onPressed(String valor) {
    setState(() {
      if (valor == 'C') {
        // Limpiar todo
        _expression = '';
        _resultado  = '0';
        _historico  = '';
      } else if (valor == '⌫') {
        // Borrar último carácter
        if (_expression.isNotEmpty) {
          _expression = _expression.substring(0, _expression.length - 1);
        }
      } else if (valor == '=') {
        // Guardar la operación antes de calcularla
        _historico = _expression;
        try {
          final exp = Parser()
              .parse(_expression.replaceAll('×', '*').replaceAll('÷', '/'));
          final res = exp.evaluate(EvaluationType.REAL, ContextModel());
          _resultado  = res.toString();
          // Para encadenar operaciones, ponemos como nueva expresión el resultado
          _expression = _resultado;
        } catch (_) {
          _resultado  = 'Error';
          _expression = '';
        }
      } else if (valor == '.') {
        // Punto decimal: no permitir dos puntos seguidos,
        // y anteponer 0 si va al inicio o tras un operador
        if (_expression.isEmpty ||
            RegExp(r'[×÷\+\-\*\/]$').hasMatch(_expression)) {
          _expression += '0.';
        } else if (!_expression.endsWith('.')) {
          _expression += '.';
        }
      } else {
        // Dígito u operador
        _expression += valor;
      }
    });
  }

  Widget _buildButton(String texto, {Color? color}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.blueGrey[800],
            padding: const EdgeInsets.all(20),
          ),
          onPressed: () => _onPressed(texto),
          child: Text(texto, style: const TextStyle(fontSize: 24)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculadora Básica')),
      body: Column(
        children: [
          // Display superior: histórico y resultado/expresión abierta
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _historico,
                    style: const TextStyle(fontSize: 24, color: Colors.grey),
                  ),
                  Text(
                    _expression.isEmpty ? _resultado : _expression,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Teclado
          Column(
            children: [
              Row(children: [
                _buildButton('7'),
                _buildButton('8'),
                _buildButton('9'),
                _buildButton('÷', color: Colors.orange),
              ]),
              Row(children: [
                _buildButton('4'),
                _buildButton('5'),
                _buildButton('6'),
                _buildButton('×', color: Colors.orange),
              ]),
              Row(children: [
                _buildButton('1'),
                _buildButton('2'),
                _buildButton('3'),
                _buildButton('-', color: Colors.orange),
              ]),
              Row(children: [
                _buildButton('0'),
                _buildButton('.', color: Colors.blueGrey),
                _buildButton('=', color: Colors.green),
                _buildButton('+', color: Colors.orange),
              ]),
              Row(children: [
                _buildButton('C', color: Colors.redAccent),
                _buildButton('⌫', color: Colors.redAccent),
                const Spacer(), // Para alinear a la izquierda
              ]),
            ],
          ),
        ],
      ),
    );
  }
}
