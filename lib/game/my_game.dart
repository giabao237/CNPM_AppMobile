import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'enemy.dart';
import 'player.dart';

class MyGame extends FlameGame {
  Player? player;
  JoystickComponent? joystick;

  double spawnTimer = 0;
  final Random random = Random();

  final List<String> enemyTypes = ["knight", "orc", "skeleton", "werewolf"];

  final Map<String, Map<String, int>> enemyConfigs = {
    "knight": {"idle": 6, "walk": 6, "attack": 12, "hurt": 4, "death": 4},
    "orc": {"idle": 6, "walk": 6, "attack": 6, "hurt": 4, "death": 4},
    "skeleton": {"idle": 6, "walk": 6, "attack": 7, "hurt": 4, "death": 4},
    "werewolf": {"idle": 6, "walk": 6, "attack": 12, "hurt": 4, "death": 4},
  };

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
      joystick!.position = Vector2(120, canvasSize.y - 120);
    }

    if (player != null) {
      player!.position = canvasSize / 2;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (player != null && joystick != null) {
      player!.move(joystick!.relativeDelta, dt);

      player!.autoAttack(dt);
    }

    spawnEnemy(dt);
  }

  void spawnEnemy(double dt) {
    if (player == null) return;

    spawnTimer += dt;

    if (spawnTimer >= 2) {
      spawnTimer = 0;

      final enemyType = enemyTypes[random.nextInt(enemyTypes.length)];
      final config = enemyConfigs[enemyType]!;

      final enemy = Enemy(
        player: player!,
        enemyFolder: enemyType,
        idleFrames: config["idle"]!,
        walkFrames: config["walk"]!,
        attackFrames: config["attack"]!,
        hurtFrames: config["hurt"]!,
        deathFrames: config["death"]!,
      );

      enemy.position = getRandomSpawnPosition();

      add(enemy);
    }
  }

  Vector2 getRandomSpawnPosition() {
    final side = random.nextInt(4);

    switch (side) {
      case 0:
        return Vector2(random.nextDouble() * size.x, -100);

      case 1:
        return Vector2(random.nextDouble() * size.x, size.y + 100);

      case 2:
        return Vector2(-100, random.nextDouble() * size.y);

      default:
        return Vector2(size.x + 100, random.nextDouble() * size.y);
    }
  }
}
