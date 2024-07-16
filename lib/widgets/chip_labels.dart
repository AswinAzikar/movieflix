import 'package:flutter/material.dart';
import 'package:movieflix/core/repository.dart';


class GenreChipsWidget extends StatefulWidget {
  final List<int> genreIds;

  const GenreChipsWidget({super.key, required this.genreIds});

  @override
  _GenreChipsWidgetState createState() => _GenreChipsWidgetState();
}

class _GenreChipsWidgetState extends State<GenreChipsWidget> {
  Map<int, String> _genreMap = {};

  @override
  void initState() {
    super.initState();
    _loadGenres();
  }

  Future<void> _loadGenres() async {
    final genreMap = await DataRepository.i.getGenreMap();
    setState(() {
      _genreMap = genreMap;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      children: widget.genreIds.map((id) {
        final genreName = _genreMap[id] ?? 'Unknown';
        return Chip(
          surfaceTintColor: Colors.red,
          label: Text(genreName),
          avatar: CircleAvatar(
            backgroundColor: const Color.fromARGB(151, 201, 38, 9),
            child: Text(
              genreName[0].toUpperCase(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      }).toList(),
    );
  }
}
