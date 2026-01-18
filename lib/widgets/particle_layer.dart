import 'dart:math';
import 'package:flutter/material.dart';

class ParticleLayer extends StatefulWidget {
  const ParticleLayer({super.key});

  @override
  ParticleLayerState createState() => ParticleLayerState();
}

class ParticleLayerState extends State<ParticleLayer> with TickerProviderStateMixin {
  final List<_Particle> _particles = [];
  late AnimationController _controller;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10), // Long duration loop
    )..repeat();
    
    _controller.addListener(() {
      _updateParticles();
    });
  }

  void _updateParticles() {
    setState(() {
      _particles.removeWhere((p) => p.isDead);
      for (var p in _particles) {
        p.update();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void addExplosion(double x, double y, Color color) {
    for (int i = 0; i < 10; i++) {
      _particles.add(_Particle(
        x: x,
        y: y,
        color: color,
        angle: _random.nextDouble() * 2 * pi,
        speed: _random.nextDouble() * 3 + 2,
        life: 1.0,
        decay: _random.nextDouble() * 0.05 + 0.02,
        size: _random.nextDouble() * 6 + 2,
      ));
    }
  }

  void addSparkles(double x, double y) {
    for (int i = 0; i < 5; i++) {
      _particles.add(_Particle(
        x: x,
        y: y,
        color: Colors.yellow,
        angle: _random.nextDouble() * 2 * pi,
        speed: _random.nextDouble() * 2 + 1,
        life: 1.0,
        decay: _random.nextDouble() * 0.03 + 0.01,
        size: _random.nextDouble() * 4 + 1,
      ));
    }
  }

  void addHeal(double x, double y) {
    for (int i = 0; i < 8; i++) {
      _particles.add(_Particle(
        x: x + (_random.nextDouble() * 40 - 20),
        y: y,
        color: Colors.greenAccent,
        angle: -pi / 2 + (_random.nextDouble() * 0.5 - 0.25), // Upwards
        speed: _random.nextDouble() * 2 + 1,
        life: 1.0,
        decay: _random.nextDouble() * 0.02 + 0.01,
        size: _random.nextDouble() * 4 + 2,
      ));
    }
  }

  void addSlash(double x, double y) {
    // Slash effect (line-like particles)
    for (int i = 0; i < 5; i++) {
      _particles.add(_Particle(
        x: x + (_random.nextDouble() * 20 - 10),
        y: y + (_random.nextDouble() * 20 - 10),
        color: Colors.white,
        angle: pi / 4 + (_random.nextDouble() * 0.2 - 0.1), // Diagonal slash
        speed: _random.nextDouble() * 5 + 5,
        life: 0.5,
        decay: 0.1,
        size: _random.nextDouble() * 2 + 1,
      ));
    }
    
    // Blood/Impact
    for (int i = 0; i < 8; i++) {
      _particles.add(_Particle(
        x: x,
        y: y,
        color: Colors.redAccent,
        angle: _random.nextDouble() * 2 * pi,
        speed: _random.nextDouble() * 4 + 2,
        life: 0.8,
        decay: 0.05,
        size: _random.nextDouble() * 3 + 2,
      ));
    }
  }

  void addLevelUp(double x, double y) {
    for (int i = 0; i < 30; i++) {
      _particles.add(_Particle(
        x: x,
        y: y,
        color: Colors.amber,
        angle: -pi / 2 + (_random.nextDouble() * pi / 2 - pi / 4), // Cone upwards
        speed: _random.nextDouble() * 5 + 3,
        life: 1.5,
        decay: _random.nextDouble() * 0.02 + 0.01,
        size: _random.nextDouble() * 6 + 2,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _ParticlePainter(_particles),
        size: Size.infinite,
      ),
    );
  }
}

class _Particle {
  double x;
  double y;
  double angle;
  double speed;
  double life; // 1.0 to 0.0
  double decay;
  double size;
  Color color;

  _Particle({
    required this.x,
    required this.y,
    required this.angle,
    required this.speed,
    required this.life,
    required this.decay,
    required this.size,
    required this.color,
  });

  bool get isDead => life <= 0;

  void update() {
    x += cos(angle) * speed;
    y += sin(angle) * speed;
    life -= decay;
    speed *= 0.95; // Friction
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;

  _ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (var p in particles) {
      if (p.isDead) continue;
      final paint = Paint()
        ..color = p.color.withValues(alpha: p.life.clamp(0.0, 1.0))
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(Offset(p.x, p.y), p.size * p.life, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) {
    return true;
  }
}
