import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnimatedIconWidget extends StatefulWidget {
  @override
  _AnimatedIconWidgetState createState() => _AnimatedIconWidgetState();
}

class _AnimatedIconWidgetState extends State<AnimatedIconWidget>
    with TickerProviderStateMixin {
  AnimationController _controller1;
  bool animate = false;
  @override
  void initState() {
    super.initState();
    _controller1 = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
      setState(() {
        _controller1.forward();
        _controller1.status == AnimationStatus.completed
            ? _controller1.reverse()
            : _controller1.forward();
      });
    return Scaffold(
      body: Center(
        child: AnimatedIcon(
          size: 34.0,
          icon: AnimatedIcons.menu_arrow,
          progress: _controller1,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller1.dispose();
    super.dispose();
  }
}
