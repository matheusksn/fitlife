import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TreinoScreen extends StatefulWidget {
  @override
  _TreinoScreenState createState() => _TreinoScreenState();
}

class _TreinoScreenState extends State<TreinoScreen> {
  List<String> _gruposMusculares = ['Peito', 'Costas', 'Ombro', 'Braço', 'Perna'];
  Map<String, List<Map<String, dynamic>>> _treinos = {};

  @override
  void initState() {
    super.initState();
    _carregarTreinos();
  }
    
  Future<void> _carregarTreinos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String treinosData = prefs.getString('treinos') ?? '{}';
    Map<String, dynamic> treinosDecoded = json.decode(treinosData);
    setState(() {
      _treinos = treinosDecoded.map<String, List<Map<String, dynamic>>>(
        (key, value) => MapEntry<String, List<Map<String, dynamic>>>(
          key,
          (value as List<dynamic>).cast<Map<String, dynamic>>(),
        ),
      );
    });
  }

  Future<void> _salvarTreinos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String treinosData = json.encode(_treinos);
    await prefs.setString('treinos', treinosData);
  }

  void _adicionarExercicio(String grupoMuscular) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController _exercicioController = TextEditingController();
        TextEditingController _cargaController = TextEditingController();
        TextEditingController _seriesController = TextEditingController();
        TextEditingController _repeticoesController = TextEditingController();

        return AlertDialog(
          title: Text('Adicionar Exercício'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: grupoMuscular,
                items: _gruposMusculares.map((String grupo) {
                  return DropdownMenuItem<String>(
                    value: grupo,
                    child: Text(grupo),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    grupoMuscular = value!;
                  });
                },
              ),
              TextField(
                controller: _exercicioController,
                decoration: InputDecoration(labelText: 'Exercício'),
              ),
              TextField(
                controller: _cargaController,
                decoration: InputDecoration(labelText: 'Carga'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _seriesController,
                decoration: InputDecoration(labelText: 'Séries'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _repeticoesController,
                decoration: InputDecoration(labelText: 'Repetições'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                String exercicio = _exercicioController.text;
                double carga = double.tryParse(_cargaController.text) ?? 0;
                int series = int.tryParse(_seriesController.text) ?? 0;
                int repeticoes = int.tryParse(_repeticoesController.text) ?? 0;

                if (exercicio.isNotEmpty) {
                  setState(() {
                    List<Map<String, dynamic>> exercicios = _treinos[grupoMuscular] ?? [];
                    exercicios.add({
                      'exercicio': exercicio,
                      'carga': carga,
                      'series': series,
                      'repeticoes': repeticoes,
                    });
                    _treinos[grupoMuscular] = exercicios;
                  });

                  Navigator.pop(context);
                  _salvarTreinos();
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Treino'),
      ),
      body: ListView.builder(
        itemCount: _gruposMusculares.length,
        itemBuilder: (context, index) {
          String grupoMuscular = _gruposMusculares[index];
          List<Map<String, dynamic>> exercicios = _treinos[grupoMuscular] ?? [];

          return ExpansionTile(
            title: Text(grupoMuscular),
            children: exercicios.map((exercicio) {
              return ListTile(
                title: Text(exercicio['exercicio']),
                subtitle: Text(
                  'Carga: ${exercicio['carga']}, Séries: ${exercicio['series']}, Repetições: ${exercicio['repeticoes']}',
                ),
              );
            }).toList(),
            trailing: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _adicionarExercicio(grupoMuscular);
              },
            ),
          );
        },
      ),
    );
  }
}
