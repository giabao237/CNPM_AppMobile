import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';

enum PlayerState {
  idle,
  walk,
  attack,
  hurt,
  death,
}

class Player extends SpriteAnimationGroupComponent<PlayerState>
    with HasGameRef<FlameGame> {
  Player();

  double attackTimer = 0;
  bool isAttacking = false;

  @override
  Future<void> onLoad() async {
    animations = {
      PlayerState.idle: await _loadAnimation("player/idle.png", 6),
      PlayerState.walk: await _loadAnimation("player/walk.png", 6),
      PlayerState.attack: await _loadAnimation("player/attack.png", 12),
      PlayerState.hurt: await _loadAnimation("player/hurt.png", 4),
      PlayerState.death: await _loadAnimation("player/death.png", 4),
    };

    current = PlayerState.idle;

    size = Vector2(100, 100);
    anchor = Anchor.center;
    position = Vector2(200, 300);
  }

  void move(Vector2 direction, double dt) {
  const speed = 200.0;

  position += direction * speed * dt;

  // Vẫn cho đổi hướng khi đang attack
  if (direction.x < -0.1) {
    scale.x = -1;
  }

  if (direction.x > 0.1) {
    scale.x = 1;
  }

  // Nếu đang attack thì không đổi animation sang walk/idle
  if (isAttacking) return;

  if (direction.length > 0.1) {
    current = PlayerState.walk;
  } else {
    current = PlayerState.idle;
  }
}
// chỉnh tốc độ đánh attacktimer 
  void autoAttack(double dt) {
    attackTimer += dt;

    if (attackTimer >= 2 && !isAttacking) {
      attackTimer = 0;
      isAttacking = true;
      current = PlayerState.attack;

      Future.delayed(const Duration(milliseconds: 1200), () {
        isAttacking = false;
      });
    }
  }

  Future<SpriteAnimation> _loadAnimation(
    String path,
    int amount,
  ) async {
    final image = await gameRef.images.load(path);

    return SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: 0.1,
        textureSize: Vector2(100, 100),
      ),
    );
  }
}