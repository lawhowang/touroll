import 'package:flutter/material.dart';
import 'package:touroll/components/loading.dart';

class Button extends StatefulWidget {
  final String label;
  final Function onPressed;
  final Color backgroundColor;
  final Color color;
  final bool loading;
  Button(
      {Key key,
      this.label,
      this.onPressed,
      this.backgroundColor,
      this.color = Colors.white,
      this.loading = false})
      : super(key: key);

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  bool pressed = false;
  @override
  Widget build(BuildContext context) {
    final Color color0 = Theme.of(context).primaryColor;
    final Color color1 = Color(0xFFF27A02);

    return Container(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: pressed ? [color1, color0] : [color0, color1])),
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          onTapDown: (_) {
            setState(() {
              pressed = true;
            });
            Future.delayed(const Duration(milliseconds: 400), () {
              setState(() {
                pressed = false;
              });
            });
          },
          onTap: () {
            if (widget.onPressed != null && !widget.loading) widget.onPressed();
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.loading
                    ? SizedBox(height: 24, width: 24, child: Loading())
                    : Text(widget.label.toUpperCase(),
                        style: TextStyle(
                            fontSize: 16,
                            color: widget.color,
                            letterSpacing: 1.1))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
