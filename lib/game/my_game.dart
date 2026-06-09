import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'player.dart';

class MyGame extends FlameGame {
  Player? player;
  JoystickComponent? joystick;

  @override
  Future<void> onLoad() async {
    player = Player();
    await add(player!);

    joystick = JoystickComponent(
      knob: CircleComponent(radius: 25),
      background: CircleComponent(radius: 60),
    );

    await add(joystick!);

    player!.position = size / 2;
    joystick!.position = Vector2(120, size.y - 120);
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);

    if (joystick != null) {
      joystick!.position = Vector2(
        120,
        canvasSize.y - 120,
      );
    }

    if (player != null) {
      player!.position = canvasSize / 2;
    }
  }

  @override
void update(double dt) {
  super.update(dt);

  if (player != null && joystick != null) {
    player!.move(
      joystick!.relativeDelta,
      dt,
    );

    player!.autoAttack(dt);
  }
}
}