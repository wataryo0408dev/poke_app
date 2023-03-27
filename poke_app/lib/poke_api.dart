import 'dart:convert';
import 'package:http/http.dart' as http;

class Pokemon{
  final String name;
  final String imageUrl;
  final int height;
  final int weight;

  Pokemon({
    required this.name,
    required this.imageUrl,
    required this.height,
    required this.weight
  });

  factory Pokemon.fromJson(Map<String, dynamic> json){
    return Pokemon(
      name: json['name'],
      imageUrl: json['sprites']['front_default'],
      height: json['height'],
      weight: json['weight'],
    );

  }
}

Future<Pokemon> fetchPokemon(String name) async{
  final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$name'));
  if(response.statusCode == 200){
    final json = jsonDecode(response.body);
    return Pokemon.fromJson(json);

  }else{
    throw Exception('データの取得に失敗しました。');
  }
}