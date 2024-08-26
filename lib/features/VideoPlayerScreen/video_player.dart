import 'package:flutter/material.dart';

class VideoPlayer extends StatefulWidget {
  final int id ;
  const VideoPlayer({super.key, required this.id});

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}