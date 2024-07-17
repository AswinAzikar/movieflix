import 'package:flutter/material.dart';
import 'package:movieflix/core/repository.dart';
import 'package:shimmer/shimmer.dart';

class GenreChipsWidget extends StatefulWidget {
  final List<int> genreIds;

  const GenreChipsWidget({super.key, required this.genreIds});

  @override
  _GenreChipsWidgetState createState() => _GenreChipsWidgetState();
}

class _GenreChipsWidgetState extends State<GenreChipsWidget> {
  Map<int, String> _genreMap = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGenres();
  }

  Future<void> _loadGenres() async {
    final genreMap = await DataRepository.i.getGenreMap();
    setState(() {
      _genreMap = genreMap;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      children: widget.genreIds.map((id) {
        if (_isLoading) {
          return Shimmer.fromColors(
            baseColor: Colors.black!,
            highlightColor: Color.fromARGB(255, 68, 67, 67)!,
            child: Chip(
              label: Container(
                width: 50,
                height: 20,
                color: const Color.fromARGB(255, 95, 94, 94),
              ),
              avatar: CircleAvatar(
                backgroundColor: Colors.grey[300],
              ),
            ),
          );
        } else {
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
        }
      }).toList(),
    );
  }
}
