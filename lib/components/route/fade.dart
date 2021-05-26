import 'package:flutter/material.dart';
import 'package:sprung/sprung.dart';

class FadeRoute extends PageRouteBuilder {
  final Widget widget;
  FadeRoute({this.widget})
      : super(
          transitionDuration: Duration(milliseconds: 400),
          reverseTransitionDuration: Duration(milliseconds: 350),
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return widget;
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return Align(
              child: FadeTransition(
                opacity: animation.drive(CurveTween(
                    curve:
                        Sprung.custom(damping: 30, stiffness: 300, mass: 1))),
                child: child,
              ),
            );
          },
        );
}
