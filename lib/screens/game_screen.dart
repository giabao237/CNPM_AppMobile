import 'package:flutter/material.dart';
import 'package:flame/game.dart';

import '../game/my_game.dart';

class GameScreen extends StatefulWidget {
  final String username;

  const GameScreen({
    super.key,
    required this.username,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  MyGame? _game;

  void _startGame() {
    setState(() {
      _game = MyGame(username: widget.username);
    });
  }

  void _restartGame() {
    setState(() {
      _game = MyGame(username: widget.username);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_game == null) {
      // ── Màn hình Start ──────────────────────────────────
      return Scaffold(
        backgroundColor: const Color(0xFF0A0E21),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFFFF6B6B)],
                  ).createShader(bounds),
                  child: const Text(
                    '⚔️ MINI GAME',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'Tiêu diệt quái vật & sinh tồn!',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 60),

                // Instructions
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.08),
                    ),
                  ),
                  child: Column(
                    children: [
                      _InstructionRow(
                        icon: Icons.sports_esports_rounded,
                        text: 'Dùng joystick để di chuyển',
                      ),
                      const SizedBox(height: 12),
                      _InstructionRow(
                        icon: Icons.auto_fix_high_rounded,
                        text: 'Nhân vật tự tấn công địch gần nhất',
                      ),
                      const SizedBox(height: 12),
                      _InstructionRow(
                        icon: Icons.star_rounded,
                        text: 'Nhặt EXP để lên cấp & tăng sức mạnh',
                      ),
                      const SizedBox(height: 12),
                      _InstructionRow(
                        icon: Icons.waves_rounded,
                        text: 'Mỗi 5 kill = 1 wave mới khó hơn',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                // Play Button
                GestureDetector(
                  onTap: _startGame,
                  child: Container(
                    width: 200,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6C63FF), Color(0xFF9B59B6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6C63FF).withOpacity(0.5),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.play_arrow_rounded,
                            color: Colors.white, size: 30),
                        SizedBox(width: 8),
                        Text(
                          'PLAY',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Back button
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Quay lại',
                    style: TextStyle(color: Colors.white38, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // ── Màn hình Game ────────────────────────────────────
    return Scaffold(
      body: GameWidget(
        game: _game!,
        overlayBuilderMap: {
          'GameOver': (context, game) {
            final myGame = game as MyGame;
            return _GameOverOverlay(
              score: myGame.score,
              wave: myGame.wave,
              onRetry: _restartGame,
              onQuit: () => Navigator.of(context).pop(),
            );
          },
        },
      ),
    );
  }
}

// ── Overlay Game Over ──────────────────────────────────────────────
class _GameOverOverlay extends StatelessWidget {
  final int score;
  final int wave;
  final VoidCallback onRetry;
  final VoidCallback onQuit;

  const _GameOverOverlay({
    required this.score,
    required this.wave,
    required this.onRetry,
    required this.onQuit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.75),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1A1035), Color(0xFF0F0D24)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: const Color(0xFFFF6B6B).withOpacity(0.4),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF6B6B).withOpacity(0.2),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon chết
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFF6B6B).withOpacity(0.15),
                  border: Border.all(
                    color: const Color(0xFFFF6B6B).withOpacity(0.4),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.sentiment_very_dissatisfied_rounded,
                  color: Color(0xFFFF6B6B),
                  size: 36,
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'GAME OVER',
                style: TextStyle(
                  color: Color(0xFFFF6B6B),
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                ),
              ),

              const SizedBox(height: 24),

              // Stats
              _StatRow(label: '🏆 Điểm số', value: '$score'),
              const SizedBox(height: 8),
              _StatRow(label: '🌊 Wave đạt được', value: '$wave'),

              const SizedBox(height: 32),

              // Retry button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.replay_rounded, size: 22),
                  label: const Text(
                    'CHƠI LẠI',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63FF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Quit button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: onQuit,
                  icon: const Icon(Icons.exit_to_app_rounded, size: 22),
                  label: const Text(
                    'THOÁT',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white54,
                    side: BorderSide(
                      color: Colors.white.withOpacity(0.2),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(color: Colors.white54, fontSize: 14)),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _InstructionRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InstructionRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF6C63FF), size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ),
      ],
    );
  }
}