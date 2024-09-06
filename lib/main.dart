// Importar as bibliotecas necessárias do Flutter
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Para comunicação com a API
import 'dart:convert';

// URL da API para obter dados de câmbio
const request = "https://api.hgbrasil.com/finance?format=json-cors&key=eb722219";

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
    theme: ThemeData(
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      hintColor: const Color.fromARGB(255, 10, 126, 0), // Cor da dica
      primaryColor: Colors.white,
    ),
  ));
}

Future<Map> getData() async {
  // Faz uma requisição HTTP para obter os dados da API e decodifica a resposta JSON
  http.Response response = await http.get(Uri.parse(request));
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  final libraController = TextEditingController(); 
  final pesoController = TextEditingController(); // Controlador para pesos argentinos

  double dolar = 0;
  double euro = 0;
  double libra = 0;
  double peso = 0; // Variável para a cotação do peso argentino

  void _realChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
    libraController.text = (real / libra).toStringAsFixed(2);
    pesoController.text = (real / peso).toStringAsFixed(2); // Adicionado
  }

  void _dolarChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
    libraController.text = (dolar * this.dolar / libra).toStringAsFixed(2);
    pesoController.text = (dolar * this.dolar / peso).toStringAsFixed(2); // Adicionado
  }

  void _euroChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
    libraController.text = (euro * this.euro / libra).toStringAsFixed(2);
    pesoController.text = (euro * this.euro / peso).toStringAsFixed(2); // Adicionado
  }

  void _libraChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double libra = double.parse(text);
    realController.text = (libra * this.libra).toStringAsFixed(2);
    dolarController.text = (libra * this.libra / dolar).toStringAsFixed(2);
    euroController.text = (libra * this.libra / euro).toStringAsFixed(2);
    pesoController.text = (libra * this.libra / peso).toStringAsFixed(2); // Adicionado
  }

  void _pesoChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double peso = double.parse(text);
    realController.text = (peso * this.peso).toStringAsFixed(2);
    dolarController.text = (peso * this.peso / dolar).toStringAsFixed(2);
    euroController.text = (peso * this.peso / euro).toStringAsFixed(2);
    libraController.text = (peso * this.peso / libra).toStringAsFixed(2);
  }

  void _clearAll() {
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
    libraController.text = "";
    pesoController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Conversor \$"),
        backgroundColor: const Color.fromARGB(255, 10, 126, 0),
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          // Verifica o estado da conexão com a API e exibe diferentes widgets de acordo
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  "Carregando Dados ...",
                  style: TextStyle(color: const Color.fromARGB(255, 10, 126, 0),),
                  textAlign: TextAlign.center,
                ),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Erro ao Carregar Dados ...",
                    style: TextStyle(color: const Color.fromARGB(255, 10, 126, 0),),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                dolar = snapshot.data!["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data!["results"]["currencies"]["EUR"]["buy"];
                libra = snapshot.data!["results"]["currencies"]["GBP"]["buy"];
                peso = snapshot.data!["results"]["currencies"]["ARS"]["buy"]; // Corrigido para ARS (Peso Argentino)
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(
                        Icons.monetization_on,
                        size: 150.0,
                        color: const Color.fromARGB(255, 10, 126, 0),
                      ),
                      TextField(
                        controller: realController,
                        style: TextStyle(
                          color: const Color.fromARGB(255, 10, 126, 0),
                          fontSize: 25.0,
                        ),
                        decoration: InputDecoration(
                          labelText: "Reais",
                          labelStyle: TextStyle(
                            color: const Color.fromARGB(255, 10, 126, 0),
                            fontSize: 20.0,
                          ),
                          border: OutlineInputBorder(),
                          prefixText: "R\$",
                        ),
                        onChanged: _realChanged,
                        keyboardType: TextInputType.number,
                      ),
                      Divider(),
                      TextField(
                        controller: dolarController,
                        style: TextStyle(
                          color: const Color.fromARGB(255, 10, 126, 0),
                          fontSize: 25.0,
                        ),
                        decoration: InputDecoration(
                          labelText: "Dólares",
                          labelStyle: TextStyle(
                            color: const Color.fromARGB(255, 10, 126, 0),
                            fontSize: 20.0,
                          ),
                          border: OutlineInputBorder(),
                          prefixText: "US\$",
                        ),
                        onChanged: _dolarChanged,
                        keyboardType: TextInputType.number,
                      ),
                      Divider(),
                      TextField(
                        controller: euroController,
                        style: TextStyle(
                          color: const Color.fromARGB(255, 10, 126, 0),
                          fontSize: 25.0,
                        ),
                        decoration: InputDecoration(
                          labelText: "Euros",
                          labelStyle: TextStyle(
                            color: const Color.fromARGB(255, 10, 126, 0),
                            fontSize: 20.0,
                          ),
                          border: OutlineInputBorder(),
                          prefixText: "€",
                        ),
                        onChanged: _euroChanged,
                        keyboardType: TextInputType.number,
                      ),
                      Divider(),
                      TextField(
                        controller: libraController,
                        style: TextStyle(
                          color: const Color.fromARGB(255, 10, 126, 0),
                          fontSize: 25.0,
                        ),
                        decoration: InputDecoration(
                          labelText: "Libras",
                          labelStyle: TextStyle(
                            color: const Color.fromARGB(255, 10, 126, 0),
                            fontSize: 20.0,
                          ),
                          border: OutlineInputBorder(),
                          prefixText: "£",
                        ),
                        onChanged: _libraChanged,
                        keyboardType: TextInputType.number,
                      ),
                      Divider(),
                      TextField(
                        controller: pesoController,
                        style: TextStyle(
                          color: const Color.fromARGB(255, 10, 126, 0),
                          fontSize: 25.0,
                        ),
                        decoration: InputDecoration(
                          labelText: "Pesos Argentinos",
                          labelStyle: TextStyle(
                            color: const Color.fromARGB(255, 10, 126, 0),
                            fontSize: 20.0,
                          ),
                          border: OutlineInputBorder(),
                          prefixText: "ARS\$",
                        ),
                        onChanged: _pesoChanged,
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}
