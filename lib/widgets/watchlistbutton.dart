// import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

class WatchlistButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function onPressed;

  // final player = AudioPlayer();

  const WatchlistButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // player.play(AssetSource('assets/sounds/button_click_sound.mp3'));
            onPressed();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  icon,
                  color: const Color.fromARGB(223, 201, 38, 9),
                ),
                const SizedBox(width: 2),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
