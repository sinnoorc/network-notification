import 'package:flutter/material.dart';
import 'package:ots/toast/anim_duration.dart';
import 'package:ots/toast/colors.dart';
import 'package:ots/toast/length.dart';
import 'package:ots/toast/text_styles.dart';

class DefaultToast extends StatefulWidget {
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final String message;
  final int duration;
  final VoidCallback? onToasted;

  const DefaultToast(
      {Key? key,
      this.backgroundColor = ToastColors.defaultToastBGColor,
      this.textStyle = ToastTextStyle.defaultTextStyle,
      this.message = " ",
      this.duration = ToastLength.short,
      this.onToasted})
      : super(key: key);

  @override
  _DefaultToastState createState() => _DefaultToastState();
}

class _DefaultToastState extends State<DefaultToast>
    with SingleTickerProviderStateMixin {
  late Animation<double> _fadeAnimation;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
        duration: ToastAnimDuration.defaultAnimDuration, vsync: this);
    _fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        curve: Curves.easeInCirc,
        reverseCurve: Curves.easeOutCirc,
        parent: _fadeController));

    _initAnimation();
  }

  void _initAnimation() async {
    _fadeController.forward();
    await Future.delayed(Duration(milliseconds: widget.duration));
    _fadeController.reverse();
    if (widget.onToasted != null) widget.onToasted!();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Material(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
        color: widget.backgroundColor,
        shadowColor: Colors.grey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
          child: Text(
            widget.message,
            textAlign: TextAlign.center,
            style: widget.textStyle,
          ),
        ),
      ),
    );
  }
}
