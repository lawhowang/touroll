import 'package:flutter/material.dart';

class TimePicker extends StatefulWidget {
  final String label;
  final TimeOfDay value;
  final Function(TimeOfDay) onChanged;
  final String Function(String) validator;
  TimePicker({Key key, this.label, this.value, this.onChanged, this.validator})
      : super(key: key);

  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker>
    with SingleTickerProviderStateMixin {
  FocusNode _focus = new FocusNode();

  TextEditingController _textController = TextEditingController();
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
    setState(() {
      _textController.text =
          widget.value != null ? widget.value.format(context) : '';
    });
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
    _textController.dispose();
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
          builder: (context, child) => TextFormField(
                controller: _textController,
                validator: widget.validator,
                onTap: () async {
                  TimeOfDay time = await showTimePicker(
                      context: context,
                      initialTime: widget.value == null ? TimeOfDay(hour: 0, minute: 0) : widget.value,
                      builder: (BuildContext context, Widget child) {
                        return MediaQuery(
                          data: MediaQuery.of(context)
                              .copyWith(alwaysUse24HourFormat: false),
                          child: child,
                        );
                      });
                  if (widget.onChanged != null) {
                    widget.onChanged(time);
                    setState(() {
                      _textController.text = time != null
                          ? time.format(context)
                          : '';
                    });
                  }
                  ;
                },
                readOnly: true,
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
              ))
    ]));
  }
}
