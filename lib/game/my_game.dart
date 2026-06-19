import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

import '../database/database_helper.dart';
import 'enemy.dart';
import 'exp_orb.dart';
import 'player.dart';

class MyGame extends FlameGame {
  final String username;

  MyGame({
    required this.username,
  });

  Player? player;
  JoystickComponent? joystick;

  final Random random = Random();

  double spawnTimer = 0;
  bool hasHitThisAttack = false;
  bool scoreSaved = false;

  int score = 0;
  int wave = 1;
  int kills = 0;
  int killsToNextWave = 5;

  late TextComponent scoreText;
  late TextComponent waveText;
  late TextComponent levelText;
  late TextComponent expText;

  final List<String> enemyTypes = [
    "knight",
    "orc",
    "skeleton",
    "werewolf",
  ];

  final Map<String, Map<String, int>> enemyConfigs = {
    "knight": {
      "idle": 6,
      "walk": 6,
      "attack": 12,
      "hurt": 4,
      "death": 4,
    },
    "orc": {
      "idle": 6,
      "walk": 6,
      "attack": 6,
      "hurt": 4,
      "death": 4,
    },
    "skeleton": {
      "idle": 6,
      "walk": 6,
      "attack": 7,
      "hurt": 4,
      "death": 4,
    },
    "werewolf": {
      "idle": 6,
      "walk": 6,
      "attack": 12,
      "hurt": 4,
      "death": 4,
    },
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

    scoreText = _makeText("Score: 0", Vector2(20, 20), Colors.white);
    waveText = _makeText("Wave: 1", Vector2(20, 45), Colors.orange);
    levelText = _makeText("LV: 1", Vector2(20, 70), Colors.white);
    expText = _makeText("EXP: 0 / 5", Vector2(20, 95), Colors.lightBlue);

    await add(scoreText);
    await add(waveText);
    await add(levelText);
    await add(expText);

    player!.position = size / 2;
    joystick!.position = Vector2(120, size.y - 120);
  }

  TextComponent _makeText(String text, Vector2 position, Color color) {
    return TextComponent(
      text: text,
      position: position,
      textRenderer: TextPaint(
        style: TextStyle(
          color: color,
          fontSize: 18,
        ),
      ),
    );
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);

    if (joystick != null) {
      joystick!.position = Vector2(120, canvasSize.y - 120);
    }

    if (player != null && !player!.isDead) {
      player!.position = canvasSize / 2;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (player != null && player!.isDead && !scoreSaved) {
      scoreSaved = true;

      DatabaseHelper.instance.saveScore(
        username: username,
        score: score,
        wave: wave,
      );
    }

    if (player != null && joystick != null && !player!.isDead) {
      player!.move(joystick!.relativeDelta, dt);
      player!.autoAttack(dt);
      playerAttackEnemies();
      collectExpOrbs();
      updateUI();
    }

    spawnEnemy(dt);
  }

  void spawnEnemy(double dt) {
    if (player == null || player!.isDead) return;

    spawnTimer += dt;

    final spawnInterval = max(0.6, 2.0 - (wave * 0.12));

    if (spawnTimer >= spawnInterval) {
      spawnTimer = 0;

      final enemyType = enemyTypes[random.nextInt(enemyTypes.length)];
      final config = enemyConfigs[enemyType]!;

      final hpScale = 1 + (wave - 1) * 0.25;
      final damageScale = 1 + (wave - 1) * 0.15;
      final speedScale = 1 + (wave - 1) * 0.05;
      final scoreScale = 1 + (wave - 1) * 0.5;

      final enemy = Enemy(
        player: player!,
        enemyFolder: enemyType,
        idleFrames: config["idle"]!,
        walkFrames: config["walk"]!,
        attackFrames: config["attack"]!,
        hurtFrames: config["hurt"]!,
        deathFrames: config["death"]!,
        onDeath: onEnemyDeath,
        maxHp: (30 * hpScale).round(),
        hp: (30 * hpScale).round(),
        damage: (10 * damageScale).round(),
        speed: 80 * speedScale,
        scoreValue: (10 * scoreScale).round(),
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

  void onEnemyDeath(Vector2 position, int scoreValue) {
    score += scoreValue;
    kills++;

    spawnExpOrb(position);
    checkWaveUp();
  }

  void checkWaveUp() {
    if (kills >= killsToNextWave) {
      kills = 0;
      wave++;
      killsToNextWave += 2;
    }
  }

  void playerAttackEnemies() {
    if (player == null) return;

    if (!player!.isAttacking) {
      hasHitThisAttack = false;
      return;
    }

    if (hasHitThisAttack) return;

    final enemies = children.whereType<Enemy>();

    for (final enemy in enemies) {
      if (enemy.isDead) continue;

      final toEnemy = enemy.position - player!.position;
      final distance = toEnemy.length;

      if (distance > 110) continue;

      final isFacingRight = player!.scale.x > 0;

      if (isFacingRight && toEnemy.x > 0) {
        enemy.takeDamage(player!.damage);
      }

      if (!isFacingRight && toEnemy.x < 0) {
        enemy.takeDamage(player!.damage);
      }
    }

    hasHitThisAttack = true;
  }

  void spawnExpOrb(Vector2 position) {
    add(
      ExpOrb(
        position: position,
        expValue: 1,
      ),
    );
  }

  void collectExpOrbs() {
    if (player == null) return;

    final orbs = children.whereType<ExpOrb>().toList();

    for (final orb in orbs) {
      final distance = player!.position.distanceTo(orb.position);

      if (distance < 45) {
        player!.gainExp(orb.expValue);
        orb.removeFromParent();
      }
    }
  }

  void updateUI() {
    if (player == null) return;

    scoreText.text = "Score: $score";
    waveText.text = "Wave: $wave";
    levelText.text = "LV: ${player!.level}";
    expText.text = "EXP: ${player!.exp} / ${player!.expToNextLevel}";
  }
}