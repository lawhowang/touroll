import 'package:flutter/material.dart';

class CustomStatefulBuilder extends StatefulWidget {
  final StatefulWidgetBuilder builder;
  final Function dispose;

  CustomStatefulBuilder({Key key, this.builder, this.dispose})
      : super(key: key);

  @override
  _CustomStatefulBuilderState createState() => _CustomStatefulBuilderState();
}

class _CustomStatefulBuilderState extends State<CustomStatefulBuilder> {
  @override
  void dispose() {
    super.dispose();
    widget.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, setState);
  }
}
