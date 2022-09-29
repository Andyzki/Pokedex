import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex/models/InformacionPoke.dart';
import 'package:pokedex/models/Pokemon.dart';

List<String> poke = [];
List<int> code = [];
String nombre = "";
int id = 0;

class homePage extends StatefulWidget {
  static const String route = "/home";
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  late Future<List<String>> listPokemon;

  Future<List<String>> getPokemon() async {
    final response = await http
        .get(Uri.parse("https://pokeapi.co/api/v2/pokemon?limit=153"));

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);

      final jsonData = jsonDecode(body);

      for (var item in jsonData["results"]) {
        nombre = item["name"];
        id += 1;
        code.add(id);
        poke.add(nombre);
      }
    } else {
      throw Exception("Fallo la Conexion");
    }
    return poke;
  }

  @override
  void initState() {
    super.initState();
    listPokemon = getPokemon();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pokedex"),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
        leading: Icon(Icons.catching_pokemon_outlined),
      ),
      body: FutureBuilder(
        future: listPokemon,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String listado = snapshot.data.toString();
            String pokemon2 = listado.replaceAll("[", "").replaceAll("]", "");
            print(snapshot.data.toString());
            final List<String> pokemones = pokemon2.split(',');
            print(pokemon2);
            return GridView.count(
              crossAxisCount: 3,
              children: pokemonList(pokemones),
            );
          } else if (snapshot.hasError) {
            return Text("Error");
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  getIndexId(String nombre) {
    int cursor = poke.indexOf(nombre);
    return cursor;
  }

  List<Widget> pokemonList(List<String> data) {
    List<Widget> poke = [];
    int entrenador = 0;
      data.asMap().forEach((index, nom) => poke.add(Card(
          child: InkWell(
        child: Container(
          child: Column(
            children: [
              Expanded(
                  child: Image.network(
                "https://raw.githubusercontent.com/PokeAPI/sprites/f301664fbbce6ccbe09f9561287e05653379f870/sprites/pokemon/${index+1}.png",
                fit: BoxFit.fill,
              )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(children: [
                  Text(nom),
                  IconButton(
                    onPressed: () => {},
                    icon: Icon(Icons.favorite_border),
                  ),
                ]),
              )
            ],
          ),
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => pokeInfo(
                        nombre: nom,
                        imagen: "https://pokefanaticos.com/pokedex/assets/images/pokemon_imagenes/${index+1}.png",
                        id: index+1,
                      )));
        },
      ))));
    return poke;
  }
}
