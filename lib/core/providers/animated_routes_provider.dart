import 'package:flutter/material.dart';

void PushSlideInAnimatedRoute(BuildContext context, {required Widget page}) {
  Navigator.push(
    context,
    PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    ),
  );
}
