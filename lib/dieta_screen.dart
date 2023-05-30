import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DietaScreen extends StatefulWidget {
  @override
  _DietaScreenState createState() => _DietaScreenState();
}

class _DietaScreenState extends State<DietaScreen> {
  List<Map<String, dynamic>> _refeicoes = [];

  Future<void> _carregarRefeicoesSalvas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? refeicoesJson = prefs.getStringList('refeicoes');

    if (refeicoesJson != null) {
      setState(() {
        _refeicoes = refeicoesJson.map((json) => Map<String, dynamic>.from(jsonDecode(json))).toList();
      });
    }
  }

  Future<void> _salvarRefeicoes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> refeicoesJson = _refeicoes.map((refeicao) => jsonEncode(refeicao)).toList();
    await prefs.setStringList('refeicoes', refeicoesJson);
  }

  void _adicionarRefeicao() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController _refeicaoController = TextEditingController();
        TextEditingController _caloriasController = TextEditingController();
        TextEditingController _alimentoController = TextEditingController();

        return AlertDialog(
          title: Text('Adicionar Refeição'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _refeicaoController,
                decoration: InputDecoration(labelText: 'Refeição'),
              ),
              TextField(
                controller: _caloriasController,
                decoration: InputDecoration(labelText: 'Calorias'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _alimentoController,
                decoration: InputDecoration(labelText: 'Alimento'),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                String refeicao = _refeicaoController.text;
                int calorias = int.tryParse(_caloriasController.text) ?? 0;
                String alimento = _alimentoController.text;

                if (refeicao.isNotEmpty && calorias > 0 && alimento.isNotEmpty) {
                  setState(() {
                    _refeicoes.add({
                      'refeicao': refeicao,
                      'calorias': calorias,
                      'alimento': alimento,
                    });
                  });

                  _salvarRefeicoes();
                  Navigator.pop(context);
                }
              },
              child: Text('Adicionar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _carregarRefeicoesSalvas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Dieta'),
      ),
      body: ListView.builder(
        itemCount: _refeicoes.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> refeicao = _refeicoes[index];
          return ListTile(
            title: Text(refeicao['refeicao']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Alimento: ${refeicao['alimento']}'),
                Text('Calorias: ${refeicao['calorias']}'),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarRefeicao,
        child: Icon(Icons.add),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DietaScreen(),
  ));
}
