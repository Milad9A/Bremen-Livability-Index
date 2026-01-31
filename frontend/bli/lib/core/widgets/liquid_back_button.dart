import 'package:bli/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';

class LiquidButtonManager {
  final AnimationController _controller;
  final State _state;
  bool _isPressed = false;
  static const double _baseSize = 48.0;

  LiquidButtonManager(this._state, {required TickerProvider vsync})
    : _controller = AnimationController(
        vsync: vsync,
        value: 1.0,
        lowerBound: 0.8,
        upperBound: 1.2,
        duration: const Duration(milliseconds: 100),
      );

  void dispose() {
    _controller.dispose();
  }

  double _getCenteredOffset(double scale) => (_baseSize * (scale - 1)) / 2;

  Future<void> _handleTapDown(TapDownDetails _) async {
    HapticFeedback.lightImpact();
    _isPressed = true;
    // We need to trigger rebuild to show animation
    // But AnimationController listener could do it if we are wrapped in AnimatedBuilder
    // However, since we return a LiquidGlass object (not a widget), the Parent must rebuild.
    // So we assume the Parent is rebuilding when controller changes or we force it.

    await _controller.animateTo(
      0.92,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
    );
    if (_isPressed && _state.mounted) {
      await _controller.animateTo(
        1.15,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _handleTapUp(
    TapUpDetails _,
    VoidCallback? onTap,
    BuildContext context,
  ) async {
    _isPressed = false;
    await _controller.animateTo(
      1.0,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
    );
    if (onTap != null) {
      onTap();
    } else {
      if (_state.mounted) Navigator.of(context).pop();
    }
  }

  void _handleTapCancel() {
    _isPressed = false;
    _controller.animateTo(
      1.0,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
    );
  }

  /// Needs to be called inside an AnimatedBuilder or a build method that listens to animation
  LiquidGlass buildLens(BuildContext context, {VoidCallback? onTap}) {
    final topPadding = MediaQuery.of(context).padding.top;
    final scale = _controller.value;
    final offset = _getCenteredOffset(scale);

    return LiquidGlass(
      width: _baseSize * scale,
      height: _baseSize * scale,
      magnification: kIsWeb ? 1.0 : 1.05,
      distortion: kIsWeb ? 0.0 : 0.1,
      distortionWidth: 30,
      position: LiquidGlassOffsetPosition(
        left: 16 - offset,
        top: (topPadding + 9) - offset,
      ),
      shape: const RoundedRectangleShape(cornerRadius: 30),
      color: AppColors.white.withValues(alpha: 0.15),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: _handleTapDown,
        onTapUp: (details) => _handleTapUp(details, onTap, context),
        onTapCancel: _handleTapCancel,
        child: ScaleTransition(
          scale: _controller,
          child: Center(
            child: Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.primaryDark,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Listenable get animation => _controller;
}
