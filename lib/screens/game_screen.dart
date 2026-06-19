import 'package:flutter/material.dart';
import 'package:flame/game.dart';

import '../game/my_game.dart';

class GameScreen extends StatelessWidget {
  final String username;

  const GameScreen({
    super.key,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        game: MyGame(
          username: username,
        ),
      ),
    );
  }
}