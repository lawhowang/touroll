import 'package:flutter/material.dart';

class Dropdown extends StatefulWidget {
  final String label;
  final String value;
  final List<String> values;
  final Function(String) onChanged;
  Dropdown({Key key, this.label, this.value, this.values, this.onChanged})
      : super(key: key);

  @override
  _DropdownState createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown>
    with SingleTickerProviderStateMixin {
  FocusNode _focus = new FocusNode();

  AnimationController _animationController;
  Animation _bgColorTween;
  Animation _fgColorTween;

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _bgColorTween = ColorTween(begin: Color(0xFFF7F7F7), end: Color(0xFFEFEFEF))
        .animate(_animationController);
  }

  @override
  void didChangeDependencies() {
    _fgColorTween =
        ColorTween(begin: Colors.black54, end: Theme.of(context).primaryColor)
            .animate(_animationController);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _focus.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focus.hasFocus) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      if (widget.label != null)
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          margin: EdgeInsets.symmetric(vertical: 6),
          child: AnimatedBuilder(
              animation: _fgColorTween,
              builder: (context, child) => Text(widget.label,
                  style: TextStyle(
                    fontSize: 16,
                    color: _fgColorTween.value,
                  ))),
        ),
      AnimatedBuilder(
          animation: _bgColorTween,
          builder: (context, child) => DropdownButtonFormField<String>(
                decoration: InputDecoration(
                    fillColor: _bgColorTween.value,
                    filled: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(6),
                      borderSide: BorderSide.none,
                    )),
                focusNode: _focus,
                onTap: () {
                  _animationController.forward();
                },
                value: widget.value,
                items: widget.values.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                onChanged: (s) {
                  widget.onChanged(s);
                  _animationController.reverse();
                },
              ))
    ]));
  }
}
