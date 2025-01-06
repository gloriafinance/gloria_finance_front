import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

CustomTransitionPage transitionCustom(Widget screen) {
  return CustomTransitionPage(
    child: screen,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const curve = Curves.easeInOut;

      var opacityTween =
          Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));
      var opacityAnimation = animation.drive(opacityTween);

      return FadeTransition(opacity: opacityAnimation, child: child);
    },
  );
}
