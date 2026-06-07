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

  @override
  Future<void> onLoad() async {
    animations = {
      PlayerState.idle: await _loadAnimation(
        "player/idle.png",
        6,
      ),

      PlayerState.walk: await _loadAnimation(
        "player/walk.png",
        6,
      ),

      PlayerState.attack: await _loadAnimation(
        "player/attack.png",
        12,
      ),

      PlayerState.hurt: await _loadAnimation(
        "player/hurt.png",
        4,
      ),

      PlayerState.death: await _loadAnimation(
        "player/death.png",
        4,
      ),
    };

    current = PlayerState.idle;

    size = Vector2(100, 100);

    position = Vector2(200, 300);
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