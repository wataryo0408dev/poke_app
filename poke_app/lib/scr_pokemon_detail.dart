


import 'package:flutter/material.dart';
import 'package:poke_app/poke_api.dart';

class ScrPokemonDetail extends StatelessWidget{

  final Pokemon pokemon;

  ScrPokemonDetail({required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pokemon.name),
      ),
      body:Center(
        child: Column(
          children: [
            Image.network(pokemon.imageUrl),
            Text("No. ${pokemon.id.toString()}"),
            Text(pokemon.name)
          ],
        ),
      )
    );
  }
}