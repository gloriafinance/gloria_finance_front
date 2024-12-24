import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

CustomTransitionPage transitionCustom(Widget screen) {
  return CustomTransitionPage(
      child: screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        var offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);

      });
}