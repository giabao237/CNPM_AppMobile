import 'package:flame/game.dart';
import 'player.dart';

class MyGame extends FlameGame {

  @override
  Future<void> onLoad() async {
    await add(Player());
  }
}