import 'package:flutter/material.dart';

class WatchList extends StatefulWidget {
  static const String path = "/Watch_List";

  const WatchList({super.key});

  @override
  State<WatchList> createState() => _WatchListState();
}

class _WatchListState extends State<WatchList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Watch List"),
      ),
      body: Container(
        color: Colors.yellow,
      ),
    );
  }
}
