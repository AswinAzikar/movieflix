// import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

class WatchlistButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function onPressed;

  // final player = AudioPlayer();

  WatchlistButton({
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
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  icon,
                  color: Color.fromARGB(223, 201, 38, 9),
                ),
                SizedBox(width: 4),
                Text(
                  text,
                  style: TextStyle(
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
