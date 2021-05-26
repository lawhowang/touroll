import 'package:flutter/material.dart';
import 'package:touroll/components/text_field.dart';
import 'package:touroll/models/place.dart';
import 'package:touroll/services/place.dart';

class GeoPicker extends StatefulWidget {
  final Function(Place) onChanged;
  GeoPicker({Key key, this.onChanged}) : super(key: key);

  @override
  _GeoPickerState createState() => _GeoPickerState();
}

class _GeoPickerState extends State<GeoPicker> {
  final placeService = PlaceService();
  FocusNode _focus = new FocusNode();
  List<Place> places = [];

  TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _focus.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find Location'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SafeArea(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 24),
              child: CustomTextField(
                label: "Location",
                hintText: "Let's type a place name to search",
                onChanged: (query) async {
                  List<Place> places = await placeService.getPlaces(query);
                  setState(() {
                    this.places = places;
                  });
                },
              ),
            ),
          ),
          Expanded(
              child: ListView.separated(
            itemCount: places.length,
            padding: EdgeInsets.symmetric(horizontal: 12),
            itemBuilder: (context, i) {
              return ListTile(
                leading: Icon(Icons.pin_drop),
                title: Text(places[i].name),
                onTap: () {
                  widget.onChanged(places[i]);
                  Navigator.pop(context);
                },
              );
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
          ))
        ],
      ),
    );
  }
}
