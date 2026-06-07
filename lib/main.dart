import 'package:flutter/material.dart';
import 'package:flame/game.dart';

import 'game/my_game.dart';

void main() {
  runApp(
    GameWidget(
      game: MyGame(),
    ),
  );
}