import 'package:flutter/material.dart';

import '../../../../app/app_router.dart';
import '../widgets/welcome_view.dart';
import '../../../lost_found/presentation/pages/item_list_page.dart';

/// Entry screen shown when the app opens.
///
/// Stacks [ItemListPage] underneath [WelcomeView] and reveals it through
/// an interactive vertical drag: the welcome layer follows the finger and
/// the listing appears from the bottom in the same gesture, so the user
/// feels they are pulling the main screen up.
///
/// A short or slow drag snaps back; reaching the distance or velocity
/// threshold completes the transition. When completed, the route is
/// replaced through [AppRouter.itemList] without duplicating the listing
/// implementation or its providers.
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  static const _completeThreshold = 0.25;
  static const _flingVelocity = 500.0;

  late final AnimationController _dragController;

  bool _dragging = false;
  double _startY = 0;

  @override
  void initState() {
    super.initState();
    _dragController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _dragController.dispose();
    super.dispose();
  }

  void _onDragStart(DragStartDetails details) {
    _dragging = true;
    _startY = details.globalPosition.dy;
    _dragController.stop();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (!_dragging) {
      return;
    }
    final height = MediaQuery.sizeOf(context).height;
    if (height <= 0) {
      return;
    }
    final dragged = (_startY - details.globalPosition.dy) / height;
    _dragController.value = dragged.clamp(0.0, 1.0);
  }

  void _onDragEnd(DragEndDetails details) {
    if (!_dragging) {
      return;
    }
    _dragging = false;
    final upwardVelocity = -(details.primaryVelocity ?? 0);

    if (_dragController.value >= _completeThreshold ||
        upwardVelocity >= _flingVelocity) {
      _dragController
          .animateTo(
            1,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
          )
          .then((_) {
            if (!mounted) {
              return;
            }
            Navigator.of(context).pushReplacementNamed(AppRouter.itemList);
          });
    } else {
      _dragController.animateBack(
        0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _dragController,
        builder: (context, _) {
          final progress = _dragController.value;
          final height = MediaQuery.sizeOf(context).height;

          return Stack(
            children: [
              const Positioned.fill(child: ItemListPage()),
              Transform.translate(
                offset: Offset(0, -progress * height),
                child: SizedBox(
                  height: height,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onVerticalDragStart: _onDragStart,
                    onVerticalDragUpdate: _onDragUpdate,
                    onVerticalDragEnd: _onDragEnd,
                    child: const WelcomeView(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
