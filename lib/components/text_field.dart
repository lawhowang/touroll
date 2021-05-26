import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final String Function(String) validator;
  final bool form;
  final TextInputType keyboardType;
  final int maxLines;
  final Function(String) onChanged;
  final bool readOnly;
  final Function onTap;
  CustomTextField(
      {Key key,
      this.label,
      this.hintText,
      this.controller,
      this.validator,
      this.keyboardType,
      this.maxLines = 1,
      this.onChanged,
      this.readOnly = false,
      this.onTap,
      this.form = false})
      : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField>
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
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              builder: (context, child) => widget.form
                  ? TextFormField(
                      focusNode: _focus,
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                          fillColor: _bgColorTween.value,
                          filled: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(6),
                            borderSide: BorderSide.none,
                          )),
                      controller: widget.controller,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: widget.keyboardType,
                      maxLines: widget.maxLines,
                      onChanged: widget.onChanged,
                      validator: widget.validator,
                      readOnly: widget.readOnly,
                      onTap: widget.onTap,)
                  : TextField(
                      focusNode: _focus,
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                          fillColor: _bgColorTween.value,
                          filled: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(6),
                            borderSide: BorderSide.none,
                          )),
                      controller: widget.controller,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: widget.keyboardType,
                      maxLines: widget.maxLines,
                      onChanged: widget.onChanged,
                      readOnly: widget.readOnly,
                      onTap: widget.onTap,
                    ))
        ],
      ),
    );
  }
}
