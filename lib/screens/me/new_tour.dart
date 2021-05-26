import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:touroll/components/button.dart';
import 'package:touroll/components/geo_picker.dart';
import 'package:touroll/components/loading.dart';
import 'package:touroll/components/login_only.dart';
import 'package:touroll/components/radio_group.dart';
import 'package:touroll/models/place.dart';
import 'package:touroll/models/point.dart';
import 'package:touroll/models/tour.dart';
import 'package:touroll/screens/tour.dart';
import 'package:touroll/services/place.dart';
import 'package:touroll/services/tour.dart';
import 'package:touroll/services/upload.dart';
import 'package:touroll/services/user.dart';
import 'package:touroll/components/text_field.dart';
import 'package:touroll/styles/calendar.dart';
import 'package:touroll/utils/image.dart';

class NewTourScreen extends StatefulWidget {
  final int id;
  NewTourScreen({Key key, this.id}) : super(key: key);

  @override
  _NewTourScreenState createState() => _NewTourScreenState();
}

class _NewTourScreenState extends State<NewTourScreen> {
  final userService = UserService();
  final tourService = TourService();
  final uploadService = UploadService();
  final placeService = PlaceService();
  bool loading = false;

  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final daysController = TextEditingController();
  final placeController = TextEditingController();
  bool published = false;
  String coverImage;
  File coverImageFile;
  Place selectedPlace;
  DateTime selectedDate;
  DateTime focusedDate = DateTime.now();
  DateTime rangeStart, rangeEnd;
  RangeSelectionMode rangeSelectionMode = RangeSelectionMode.toggledOn;
  bool uploadingCover = false;
  Future<void> loadingTour;

  Future<void> loadExistingTour() async {
    Tour tour = await tourService.getTour(widget.id);
    List<double> coordinates = tour.location?.coordinates;
    Place p;
    if (coordinates != null) {
      p = await placeService.coordinatesToPlace(coordinates);
    }
    setState(() {
      titleController.text = tour.title;
      published = tour.published;
      descriptionController.text = tour.description;
      daysController.text = tour.days.toString();
      priceController.text = tour.price.toString();
      rangeStart = tour.startDate;
      rangeEnd = tour.endDate;
      focusedDate = rangeStart;
      coverImage = tour.coverImage;
      selectedPlace = p;
      placeController.text = p.name ?? p.formatted_address;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      loadingTour = loadExistingTour();
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    daysController.dispose();
  }

  void selectImage() async {
    setState(() {
      uploadingCover = true;
    });
    try {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
      coverImageFile = File(pickedFile.path);
      //
      final id = await uploadService.upload(coverImageFile);
      setState(() {
        coverImage = id;
      });
    } catch (ex) {
      print(ex.toString());
      coverImageFile = null;
      coverImage = null;
    }
    setState(() {
      uploadingCover = false;
    });
  }

  Future<void> createTour() async {
    setState(() {
      loading = true;
    });
    try {
      final title = titleController.text;
      final description = descriptionController.text;
      final days = num.tryParse(daysController.text);
      final price = num.tryParse(priceController.text);
      final startDate = rangeStart;
      final endDate = rangeEnd;
      final location = selectedPlace == null
          ? null
          : Point(type: 'Point', coordinates: [
              selectedPlace.geometry.location.lat,
              selectedPlace.geometry.location.lng
            ]);

      Tour t = widget.id == null
          ? await tourService.createTour(
              title: title,
              description: description,
              coverImage: coverImage,
              published: published,
              startDate: startDate,
              endDate: endDate,
              days: days,
              price: price,
              location: location)
          : await tourService.updateTour(widget.id,
              title: title,
              description: description,
              coverImage: coverImage,
              published: published,
              startDate: startDate,
              endDate: endDate,
              days: days,
              price: price,
              location: location);

      if (t?.id != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => TourScreen(id: t.id)));
      }
    } catch (ex) {}
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoginOnly(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: Text(widget.id == null ? 'Create Tour' : 'Edit Tour'),
              ),
              body: FutureBuilder(
                  future: loadingTour,
                  builder: (context, snapshot) {
                    if (loadingTour != null &&
                        snapshot.connectionState != ConnectionState.done) {
                      return Center(
                        child: Loading(),
                      );
                    }
                    return Form(
                      key: _formKey,
                      child: CustomScrollView(shrinkWrap: true, slivers: [
                        SliverToBoxAdapter(
                          child: Container(
                            height: 240,
                            child: uploadingCover
                                ? Center(child: Loading())
                                : coverImage == null
                                    ? Container(
                                        child: Button(
                                            label: 'Upload cover',
                                            onPressed: () => selectImage()),
                                      )
                                    : InkWell(
                                        child: coverImageFile == null
                                            ? CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl: ImageUtil
                                                    .getImageUrlByIdentifier(
                                                        ImageType.TOUR_COVER,
                                                        coverImage))
                                            : Image.file(coverImageFile,
                                                fit: BoxFit.cover),
                                        onTap: () => selectImage(),
                                      ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            child: Column(
                              children: [
                                CustomTextField(
                                  form: true,
                                  controller: titleController,
                                  label: 'Title',
                                  validator: (value) {
                                    if (value.trim().isEmpty) {
                                      return 'Title is required';
                                    }
                                  },
                                ),
                                Container(
                                  height: 12,
                                ),
                                RadioGroup(
                                  options: {'Public': true, 'Private': false},
                                  selected: published,
                                  onChanged: (isPublic) {
                                    setState(() {
                                      published = isPublic;
                                    });
                                  },
                                ),
                                Container(
                                  height: 8,
                                ),
                                CustomTextField(
                                  form: true,
                                  controller: descriptionController,
                                  label: 'Description',
                                  validator: (value) {
                                    if (value.trim().isEmpty) {
                                      return 'Description is required';
                                    }
                                  },
                                ),
                                Container(
                                  height: 12,
                                ),
                                CustomTextField(
                                  label: 'Location',
                                  controller: placeController,
                                  readOnly: true,
                                  onTap: () {
                                    setState(() {
                                      selectedPlace = null;
                                      placeController.text = '';
                                    });
                                    Navigator.of(context, rootNavigator: true)
                                        .push(MaterialPageRoute(
                                            builder: (_) => GeoPicker(
                                                  onChanged: (p) {
                                                    setState(() {
                                                      selectedPlace = p;
                                                      placeController.text =
                                                          p.name;
                                                    });
                                                  },
                                                )));
                                  },
                                ),
                                Container(
                                  height: 12,
                                ),
                                CustomTextField(
                                  form: true,
                                  controller: daysController,
                                  keyboardType: TextInputType.number,
                                  label: 'No of days',
                                  validator: (value) {
                                    if (value.trim().isEmpty) {
                                      return 'Number of days is required';
                                    }
                                    num n = num.tryParse(value);
                                    if (n == null || n <= 0 || n > 364) {
                                      return 'Invalid no of days';
                                    }
                                  },
                                ),
                                Container(
                                  height: 12,
                                ),
                                CustomTextField(
                                  form: true,
                                  controller: priceController,
                                  keyboardType: TextInputType.number,
                                  label: 'Price',
                                  validator: (value) {
                                    if (value.trim().isEmpty) {
                                      return 'Price is required';
                                    }
                                    num n = num.tryParse(value);
                                    if (n == null || n <= 0 || n >= 999999999) {
                                      return 'Invalid price';
                                    }
                                  },
                                ),
                                Container(
                                  height: 12,
                                ),
                                TableCalendar(
                                    availableGestures:
                                        AvailableGestures.horizontalSwipe,
                                    calendarStyle: customCalendarStyle(context),
                                    headerStyle:
                                        HeaderStyle(titleCentered: true),
                                    calendarFormat: CalendarFormat.month,
                                    firstDay: DateTime.now(),
                                    lastDay: DateTime.now()
                                        .add(const Duration(days: 365)),
                                    rangeStartDay: rangeStart,
                                    rangeEndDay: rangeEnd,
                                    focusedDay: focusedDate,
                                    rangeSelectionMode: rangeSelectionMode,
                                    selectedDayPredicate: (day) {
                                      return isSameDay(selectedDate, day);
                                    },
                                    onDaySelected: (selectedDay, focusedDay) {
                                      if (!isSameDay(
                                          selectedDate, selectedDay)) {
                                        setState(() {
                                          selectedDate = selectedDay;
                                          focusedDate = focusedDay;
                                          rangeStart =
                                              null; // Important to clean those
                                          rangeEnd = null;
                                          rangeSelectionMode =
                                              RangeSelectionMode.toggledOff;
                                        });
                                      }
                                    },
                                    onRangeSelected: (start, end, focusedDay) {
                                      setState(() {
                                        selectedDate = null;
                                        focusedDate = focusedDay;
                                        rangeStart = start;
                                        rangeEnd = end;
                                        rangeSelectionMode =
                                            RangeSelectionMode.toggledOn;
                                      });
                                    },
                                    availableCalendarFormats: {
                                      CalendarFormat.month: 'Month'
                                    },
                                    onPageChanged: (focusedDay) {
                                      focusedDate = focusedDay;
                                    }),
                              ],
                            ),
                          ),
                        ),
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                height: 12,
                              ),
                              Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 8),
                                  child: SafeArea(
                                    child: Button(
                                        loading: loading,
                                        label: widget.id == null
                                            ? 'Create'
                                            : 'Update',
                                        onPressed: uploadingCover
                                            ? null
                                            : () {
                                                if (!_formKey.currentState
                                                    .validate()) {
                                                  return;
                                                }
                                                if (rangeStart == null ||
                                                    rangeEnd == null) {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          content: Text(
                                                              'Please select covered dates of this tour'),
                                                          actions: [
                                                            TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        context),
                                                                child:
                                                                    Text('OK'))
                                                          ],
                                                        );
                                                      });
                                                  return;
                                                }
                                                createTour();
                                              }),
                                  )),
                            ],
                          ),
                        ),
                      ]),
                    );
                  }),
            ));
  }
}
