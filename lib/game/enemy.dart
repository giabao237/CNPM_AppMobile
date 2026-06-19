import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'player.dart';

enum EnemyState { idle, walk, attack, hurt, death }

class Enemy extends SpriteAnimationGroupComponent<EnemyState>
    with HasGameRef<FlameGame> {
  final Player player;
  final String enemyFolder;

  final int idleFrames;
  final int walkFrames;
  final int attackFrames;
  final int hurtFrames;
  final int deathFrames;

  final void Function(Vector2 position, int scoreValue) onDeath;

  Enemy({
    required this.player,
    required this.enemyFolder,
    required this.idleFrames,
    required this.walkFrames,
    required this.attackFrames,
    required this.hurtFrames,
    required this.deathFrames,
    required this.onDeath,
    required this.maxHp,
    required this.hp,
    required this.damage,
    required this.speed,
    required this.scoreValue,
  });

  double speed;

  int maxHp;
  int hp;
  int damage;
  int scoreValue;

  double attackCooldown = 0;

  bool isDead = false;
  bool isHurting = false;

  @override
  Future<void> onLoad() async {
    animations = {
      EnemyState.idle: await _loadAnimation("enemies/$enemyFolder/idle.png", idleFrames),
      EnemyState.walk: await _loadAnimation("enemies/$enemyFolder/walk.png", walkFrames),
      EnemyState.attack: await _loadAnimation("enemies/$enemyFolder/attack.png", attackFrames),
      EnemyState.hurt: await _loadAnimation("enemies/$enemyFolder/hurt.png", hurtFrames),
      EnemyState.death: await _loadAnimation("enemies/$enemyFolder/death.png", deathFrames),
    };

    current = EnemyState.walk;
    size = Vector2(80, 80);
    anchor = Anchor.center;
  }

  @override
  void update(double dt) {
    super.update(dt);

    attackCooldown += dt;

    if (isDead) return;
    if (isHurting) return;

    moveToPlayer(dt);
  }

  void moveToPlayer(double dt) {
    final direction = player.position - position;
    final distance = direction.length;

    if (distance > 60) {
      final normalizedDirection = direction.normalized();

      position += normalizedDirection * speed * dt;
      current = EnemyState.walk;

      if (normalizedDirection.x < -0.1) scale.x = -1;
      if (normalizedDirection.x > 0.1) scale.x = 1;
    } else {
      current = EnemyState.attack;

      if (attackCooldown >= 1.0) {
        attackCooldown = 0;
        player.takeDamage(damage);
      }
    }
  }

  void takeDamage(int damage) {
    if (isDead || isHurting) return;

    hp -= damage;

    if (hp <= 0) {
      hp = 0;
      die();
    } else {
      isHurting = true;
      current = EnemyState.hurt;

      Future.delayed(const Duration(milliseconds: 400), () {
        if (!isDead) {
          isHurting = false;
          current = EnemyState.walk;
        }
      });
    }
  }

  void die() {
    if (isDead) return;

    isDead = true;
    current = EnemyState.death;

    onDeath(position.clone(), scoreValue);

    Future.delayed(const Duration(milliseconds: 600), () {
      removeFromParent();
    });
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
    final barWidth = size.x;

    final bgPaint = Paint()..color = const Color(0xFF444444);
    final hpPaint = Paint()..color = const Color(0xFFFF0000);

    canvas.drawRect(Rect.fromLTWH(0, -12, barWidth, 6), bgPaint);
    canvas.drawRect(Rect.fromLTWH(0, -12, barWidth * hpPercent, 6), hpPaint);
  }
}