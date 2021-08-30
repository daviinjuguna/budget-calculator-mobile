import 'package:flutter/material.dart';
import 'package:sortika_budget_calculator/core/utils/debouncer.dart';

/// Toast displaying brief message on overlay
class ToastWidget extends StatefulWidget {
  ToastWidget({
    Key? key,
    required this.child,
    this.fadeDuration = 350,
    this.fadeSeconds = 2,
  }) : super(key: key);
  final Widget child;
  final int fadeDuration;
  final int fadeSeconds;

  @override
  _ToastWidgetState createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<ToastWidget>
    with SingleTickerProviderStateMixin {
  late final _animationController = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: widget.fadeDuration),
  );
  late final _fadeAnimation =
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);

  late final _debouncer;

  @override
  void initState() {
    _debouncer = Debouncer(seconds: widget.fadeSeconds);
    super.initState();

    showIt();
    _debouncer.run(action: hideIt);
  }

  @override
  void dispose() {
    super.dispose();
    _debouncer.close();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    _debouncer.close();
    _animationController.stop();
    super.deactivate();
  }

  ///show the toast, unhide it
  showIt() {
    _animationController.forward();
  }

  ///hide the toast message
  hideIt() {
    _animationController.reverse();
    _debouncer.close();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Center(
        child: Material(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: widget.child,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
            ),
          ),
        ),
      ),
    );
  }
}
