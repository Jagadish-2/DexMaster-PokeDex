import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex/Screens/pokemon_details_screen.dart';
import 'package:pokedex/utils/context_extension.dart';
import 'DrawerScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var pokeApi =
      "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/mastelate r/pokedex.json";
  List pokdex = [];

  @override
  void initState() {
    super.initState();
    if (mounted) {
      fetchPokemonData();
    }
  }

  @override
  Widget build(BuildContext context) {
    var width1 = MediaQuery.of(context).size.width;
    var heigth1 = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        key: _scaffoldKey,
        endDrawer: DrawerScreen(),
        body: Stack(
          children: [
            Positioned(
              top: -50,
              right: -50,
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.5), // Set the opacity here
                  BlendMode.modulate,
                ),
                child: Image.asset(
                  'assets/images/pokeball_white.png',
                  width: 200,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Positioned(
              top: 90, // Position the button where you want
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.menu,color: Colors.black,size: 35,),
                onPressed: () {
                  _scaffoldKey.currentState?.openEndDrawer();
                },
              ),
            ),
            const Positioned(
                top: 100,
                left: 20,
                child: Text('PokeDex',style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),)),
            Positioned(
              top: 150,
              bottom: 0,
              width: width1,
              child: Column(
                children: [
                  pokdex.isNotEmpty
                      ? Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, childAspectRatio: 1.4),
                            itemCount: pokdex.length,
                            itemBuilder: (context, index) {
                              var type = pokdex[index]['type'][0];
                              return InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 12),
                                  child: Container(
                                    decoration:  BoxDecoration(
                                        color: type == 'Grass' ?Colors.greenAccent : type == 'Fire' ? Colors.redAccent : type == 'Water' ? Colors.lightBlue :
                                            type == "Electric" ? Colors.yellow : type == 'Rock' ? Colors.grey : type == 'Ground' ? Colors.brown:
                                                type == 'Psychic' ? Colors.indigo : type == 'Fighting' ? Colors.orange : type == 'Bug' ? Colors.lightGreenAccent:
                                                    type == 'Ghost' ? Colors.deepPurple : type == "Normal" ? Colors.blueGrey : type == 'Poison' ? Colors.deepPurpleAccent :
                                                        type == 'Ice' ? Colors.blueAccent : type == "Dragon" ? Colors.orangeAccent : Colors.pink,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          bottom: -10,
                                          right: -10,
                                          child: Image.asset(
                                            'assets/images/pokeball_white.png',
                                            height: 100,
                                            fit: BoxFit.fitHeight,
                                          ),
                                        ),
                                        Positioned(
                                          top: 20,
                                          left: 5,
                                          child: Text(
                                            pokdex[index]['name'],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Colors.white),
                                          ),
                                        ),
                                        Positioned(
                                          top: 45,
                                          left: 5,
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                              color: Colors.black26,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0,
                                                  right: 8.0,
                                                  top: 4.0,
                                                  bottom: 4.0),
                                              child: Text(
                                                type.toString(),
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 2,
                                          right: 1,
                                          child: Hero(
                                            tag: index,
                                            child: CachedNetworkImage(
                                              imageUrl: pokdex[index]['img'],
                                              height: 90,
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: (){
                                  context.navigateToScreen(child: PokemonDetailsScreen(
                                    pokemonDetails: pokdex[index],
                                    color: type == 'Grass' ?Colors.greenAccent : type == 'Fire' ? Colors.redAccent : type == 'Water' ? Colors.lightBlue :
                                    type == "Electric" ? Colors.yellow : type == 'Rock' ? Colors.grey : type == 'Ground' ? Colors.brown:
                                    type == 'Psychic' ? Colors.indigo : type == 'Fighting' ? Colors.orange : type == 'Bug' ? Colors.lightGreenAccent:
                                    type == 'Ghost' ? Colors.deepPurple : type == "Normal" ? Colors.blueGrey : type == 'Poison' ? Colors.deepPurpleAccent :
                                    type == 'Ice' ? Colors.blueAccent : type == "Dragon" ? Colors.orangeAccent : Colors.pink,
                                    heroTag: index,
                                  ));
                                },
                              );
                            },
                          ),
                        )
                      : const Center(
                          child: CircularProgressIndicator(),
                        )
                ],
              ),
            ),
          ],
        ));
  }

  void fetchPokemonData() {
    var url = Uri.https('raw.githubusercontent.com',
        'Biuni/PokemonGO-Pokedex/master/pokedex.json');
    http.get(url).then((value) {
      if (value.statusCode == 200) {
        var decodedJsonData = jsonDecode(value.body);
        //print(decodedJsonData);
        pokdex = decodedJsonData['pokemon'];
        //print(pokdex);
        setState(() {});
      }
    });
  }
}
