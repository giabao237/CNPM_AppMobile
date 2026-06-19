import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';

enum PlayerState { idle, walk, attack, hurt, death }

class Player extends SpriteAnimationGroupComponent<PlayerState>
    with HasGameRef<FlameGame> {
  Player();

  double attackTimer = 0;
  bool isAttacking = false;

  int maxHp = 1000;
  int hp = 1000;

  int damage = 50;
  bool isDead = false;

  int level = 1;
  int exp = 0;
  int expToNextLevel = 5;

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
    if (isDead) return;

    const speed = 200.0;

    position += direction * speed * dt;

    if (direction.x < -0.1) {
      scale.x = -1;
    }

    if (direction.x > 0.1) {
      scale.x = 1;
    }

    if (isAttacking) return;

    if (direction.length > 0.1) {
      current = PlayerState.walk;
    } else {
      current = PlayerState.idle;
    }
  }

  void autoAttack(double dt) {
    if (isDead) return;

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

  void takeDamage(int amount) {
    if (isDead) return;

    hp -= amount;

    if (hp <= 0) {
      hp = 0;
      die();
    } else {
      current = PlayerState.hurt;
    }
  }

  void die() {
    if (isDead) return;

    isDead = true;
    current = PlayerState.death;

    Future.delayed(const Duration(milliseconds: 400), () {
      removeFromParent();
    });
  }

  void gainExp(int amount) {
    if (isDead) return;

    exp += amount;

    while (exp >= expToNextLevel) {
      exp -= expToNextLevel;
      levelUp();
    }
  }

  void levelUp() {
    level++;

    expToNextLevel += 5;

    maxHp += 10;
    hp = maxHp;

    damage += 2;
  }

  Future<SpriteAnimation> _loadAnimation(String path, int amount) async {
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

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final hpPercent = hp / maxHp;
    final expPercent = exp / expToNextLevel;

    final backgroundPaint = Paint()..color = const Color(0xFF444444);
    final hpPaint = Paint()..color = const Color(0xFF00FF00);
    final expPaint = Paint()..color = const Color(0xFF00AAFF);

    final barWidth = size.x;

    canvas.drawRect(
      Rect.fromLTWH(0, -18, barWidth, 8),
      backgroundPaint,
    );

    canvas.drawRect(
      Rect.fromLTWH(0, -18, barWidth * hpPercent, 8),
      hpPaint,
    );

    canvas.drawRect(
      Rect.fromLTWH(0, -8, barWidth, 5),
      backgroundPaint,
    );

    canvas.drawRect(
      Rect.fromLTWH(0, -8, barWidth * expPercent, 5),
      expPaint,
    );
  }
}