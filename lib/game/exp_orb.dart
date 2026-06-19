import 'dart:ui';

import 'package:flame/components.dart';

class ExpOrb extends CircleComponent {
  final int expValue;

  ExpOrb({
    required Vector2 position,
    this.expValue = 1,
  }) : super(
          radius: 8,
          position: position,
          anchor: Anchor.center,
          paint: Paint()..color = const Color(0xFF00FFFF),
        );
}