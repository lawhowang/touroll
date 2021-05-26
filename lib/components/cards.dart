import 'package:flutter/material.dart';
import 'package:touroll/models/card.dart';

class Cards extends StatefulWidget {
  final List<CardInput> input;
  Cards({Key key, @required this.input}) : super(key: key);

  @override
  _CardsState createState() => _CardsState();
}

class _CardsState extends State<Cards> {
  @override
  Widget build(BuildContext context) {
    final cardSize = MediaQuery.of(context).size.width * 0.25;
    return ListView.builder(
        itemCount: widget?.input?.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            height: cardSize,
            width: cardSize,
            child: Text('test card'),
          );
        });
  }
}
