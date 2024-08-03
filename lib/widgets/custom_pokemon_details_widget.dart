import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomPokemonDetailsWidget extends StatefulWidget {
  final double width;
  final pokemonDetails;
  final String name;
  const CustomPokemonDetailsWidget({
    super.key,
    required this.width,
    this.pokemonDetails,
    required this.name,
  });

  @override
  State<CustomPokemonDetailsWidget> createState() => _CustomPokemonDetailsWidgetState();
}

class _CustomPokemonDetailsWidgetState extends State<CustomPokemonDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: widget.width * 0.3,
            child: Text(
              widget.name,
              style: TextStyle(color: Colors.blueGrey, fontSize: 18),
            ),
          ),
          const SizedBox(width: 8), // Add some space between the two text widgets
          Expanded(
            child: Text(
              widget.pokemonDetails,
              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis, // Add overflow handling
              softWrap: true, // Ensure text can wrap to the next line
            ),
          ),
        ],
      ),
    );
  }
}
