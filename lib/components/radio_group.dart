import 'package:flutter/material.dart';

class RadioGroup extends StatefulWidget {
  final Map<String, dynamic> options;
  final dynamic selected;
  final Function(dynamic) onChanged;
  RadioGroup(
      {Key key,
      @required this.onChanged,
      @required this.options,
      this.selected})
      : super(key: key);

  @override
  _RadioGroupState createState() => _RadioGroupState();
}

class _RadioGroupState extends State<RadioGroup> {
  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    widget.options.forEach((key, value) {
      widgets.add(Expanded(
          child: GestureDetector(
              onTap: () {
                widget.onChanged(value);
              },
              child: AnimatedContainer(
                  height: 48,
                  color: widget.selected == value
                      ? Theme.of(context).primaryColor
                      : Color(0xFFF7F7F7),
                  padding: EdgeInsets.symmetric(vertical: 12),
                  duration: const Duration(milliseconds: 200),
                  child: Center(
                      child: AnimatedDefaultTextStyle(
                    style: TextStyle(
                      fontSize: 16,
                      color: widget.selected == value
                          ? Colors.white
                          : Colors.black54,
                    ),
                    duration: const Duration(milliseconds: 200),
                    child: Text(key),
                  ))))));
    });
    return Container(
        color: Color(0xFFF7F7F7),
        margin: EdgeInsets.symmetric(vertical: 12),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: widgets,
            )));
  }
}
