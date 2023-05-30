import 'package:flutter/material.dart';

class IMCScreen extends StatefulWidget {
  @override
  _IMCScreenState createState() => _IMCScreenState();
}

class _IMCScreenState extends State<IMCScreen> {
  TextEditingController _alturaController = TextEditingController();
  TextEditingController _pesoController = TextEditingController();
  String _resultado = '';

  void _calcularIMC() {
    double altura = double.tryParse(_alturaController.text) ?? 0;
    double peso = double.tryParse(_pesoController.text) ?? 0;

    double imc = peso / (altura * altura);

    String resultado;

    if (imc < 18.5) {
      resultado = 'Abaixo do Peso';
    } else if (imc >= 18.5 && imc < 25) {
      resultado = 'Peso Normal';
    } else if (imc >= 25 && imc < 30) {
      resultado = 'Sobrepeso';
    } else if (imc >= 30 && imc < 35) {
      resultado = 'Obesidade Grau 1';
    } else if (imc >= 35 && imc < 40) {
      resultado = 'Obesidade Grau 2';
    } else {
      resultado = 'Obesidade Grau 3';
    }

    setState(() {
      _resultado = resultado;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calculadora de IMC',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _alturaController,
              decoration: InputDecoration(labelText: 'Altura (metros)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: _pesoController,
              decoration: InputDecoration(labelText: 'Peso (kg)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _calcularIMC,
              child: Text('Calcular'),
            ),
            SizedBox(height: 16.0),
            Text(
              'Resultado: $_resultado',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
