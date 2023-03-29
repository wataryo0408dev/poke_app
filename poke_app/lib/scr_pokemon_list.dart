
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:poke_app/poke_api.dart';
import 'package:poke_app/scr_pokemon_detail.dart';

import 'package:http/http.dart' as http;

class ScrPokemonList extends StatelessWidget{

  Future<Map<String, dynamic>> getPokemonSpecies(String url) async{
    final response = await http.get(Uri.parse(url));
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

Future<List<Pokemon>> getPokemonList() async{
  final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=3'));
  final pokemonListJson = jsonDecode(response.body)['results'] as List<dynamic>;
  final pokemonList = <Pokemon>[];
  for (final pokemon in pokemonListJson) {
    final speciesUrl = (await getPokemonSpecies(pokemon['url']))['species']['url'] as String;
    final speciesData = await getPokemonSpecies(speciesUrl);
    final name = speciesData['names'].firstWhere((data) => data['language']['name'] == 'ja')['name'] as String;
    final id = speciesData['id'];
    final imageUrl = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${pokemonListJson.indexOf(pokemon) + 1}.png';
    pokemonList.add(Pokemon(
      name: name,
      id: id,
      imageUrl: imageUrl,
    ));
  }
  return pokemonList;
}

  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        title: const Text('ポケモンリスト'),
      ),
      body: FutureBuilder<List<Pokemon>>(
        future: getPokemonList(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final pokemon = snapshot.data![index];
                return ListTile(
                  leading: Image.network(pokemon.imageUrl),
                  title: Text(pokemon.name),
                  subtitle: Text("No.${pokemon.id.toString()}"),
                  trailing: const Icon(Icons.arrow_forward),

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ScrPokemonDetail(),)

                    );
                  },
                );
              },
            );
          }else{
            return Center(
              // child: CircularProgressIndicator(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const[
                  CircularProgressIndicator(),
                  Padding(padding: EdgeInsets.all(10)),
                  Text("データを取得中です")
                ],
              ),
            );
          }
        },
      ),
    );
  }
}