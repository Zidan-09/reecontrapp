import 'package:flutter/material.dart';

/// Minimal welcome content shown above the main listing.
///
/// Solid background, centered logo with preserved aspect ratio, app name
/// and a static hint with a softly animated `^` arrow. The hint animation
/// owns its single [AnimationController] and loops while visible.
///
/// Follows the presentation conventions of the `lost_found` pages:
/// Material 3, Portuguese user-facing texts and a responsive layout that
/// respects [SafeArea] without fixed full-screen dimensions.
///
/// This widget owns no [Scaffold]: it is layered above the listing inside
/// [WelcomePage], which keeps a single [Scaffold] alive underneath.
class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _hintController;
  late final Animation<double> _hintOffset;

  @override
  void initState() {
    super.initState();
    _hintController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _hintOffset = Tween<double>(begin: 0, end: -6).animate(
      CurvedAnimation(parent: _hintController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hintController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ColoredBox(
      color: colorScheme.primary,
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'public/logo.png',
                      width: 144,
                      height: 144,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Reencontrapp',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(color: colorScheme.onPrimary),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _hintOffset,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _hintOffset.value),
                  child: child,
                );
              },
              child: Text(
                '^',
                style: Theme.of(context).textTheme.headlineMedium
                    ?.copyWith(color: colorScheme.onPrimary),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'arraste para cima',
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: colorScheme.onPrimary),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
