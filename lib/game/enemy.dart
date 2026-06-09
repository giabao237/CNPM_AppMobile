import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'player.dart';

enum EnemyState {
  idle,
  walk,
  attack,
  hurt,
  death,
}

class Enemy extends SpriteAnimationGroupComponent<EnemyState>
    with HasGameRef<FlameGame> {
  final Player player;
  final String enemyFolder;

  final int idleFrames;
  final int walkFrames;
  final int attackFrames;
  final int hurtFrames;
  final int deathFrames;

  Enemy({
    required this.player,
    required this.enemyFolder,
    required this.idleFrames,
    required this.walkFrames,
    required this.attackFrames,
    required this.hurtFrames,
    required this.deathFrames,
  });

  double speed = 80;
  int hp = 30;
  bool isDead = false;

  @override
  Future<void> onLoad() async {
    animations = {
      EnemyState.idle: await _loadAnimation(
        "enemies/$enemyFolder/idle.png",
        idleFrames,
      ),
      EnemyState.walk: await _loadAnimation(
        "enemies/$enemyFolder/walk.png",
        walkFrames,
      ),
      EnemyState.attack: await _loadAnimation(
        "enemies/$enemyFolder/attack.png",
        attackFrames,
      ),
      EnemyState.hurt: await _loadAnimation(
        "enemies/$enemyFolder/hurt.png",
        hurtFrames,
      ),
      EnemyState.death: await _loadAnimation(
        "enemies/$enemyFolder/death.png",
        deathFrames,
      ),
    };

    current = EnemyState.walk;
    size = Vector2(80, 80);
    anchor = Anchor.center;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isDead) return;

    moveToPlayer(dt);
  }

  void moveToPlayer(double dt) {
    final direction = player.position - position;

    if (direction.length > 50) {
      final normalizedDirection = direction.normalized();

      position += normalizedDirection * speed * dt;
      current = EnemyState.walk;

      if (normalizedDirection.x < -0.1) {
        scale.x = -1;
      }

      if (normalizedDirection.x > 0.1) {
        scale.x = 1;
      }
    } else {
      current = EnemyState.attack;
    }
  }

  void takeDamage(int damage) {
    if (isDead) return;

    hp -= damage;

    if (hp <= 0) {
      die();
    } else {
      current = EnemyState.hurt;
    }
  }

  void die() {
    isDead = true;
    current = EnemyState.death;

    Future.delayed(const Duration(milliseconds: 600), () {
      removeFromParent();
    });
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