import 'package:flutter/material.dart';
import 'package:fitlife/imc_screen.dart';
import 'package:fitlife/dieta_screen.dart';
import 'package:fitlife/treino_screen.dart';

void main() => runApp(CalculadoraIMCApp());

class CalculadoraIMCApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitLife',
      theme: ThemeData(
        primaryColor: Colors.red,
        scaffoldBackgroundColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.redAccent,
            textStyle: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
            padding: EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 32.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/imc': (context) => IMCScreen(),
        '/dieta': (context) => DietaScreen(),
        '/treino': (context) => TreinoScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FitLife',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
        elevation: 0.0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/imc');
              },
              child: Text('Calculadora de IMC'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/dieta');
              },
              child: Text('Registro de Dieta'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/treino');
              },
              child: Text('Registro de Treino'),
            ),
          ],
        ),
      ),
    );
  }
}
