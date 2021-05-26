import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:touroll/components/button.dart';
import 'package:touroll/components/dropdown.dart';
import 'package:touroll/components/loading.dart';
import 'package:touroll/components/login_only.dart';
import 'package:touroll/components/radio_group.dart';
import 'package:touroll/components/time_picker.dart';
import 'package:touroll/models/activity.dart';
import 'package:touroll/models/tour.dart';
import 'package:touroll/screens/tour.dart';
import 'package:touroll/services/activity.dart';
import 'package:touroll/services/tour.dart';
import 'package:touroll/services/upload.dart';
import 'package:touroll/services/user.dart';
import 'package:touroll/components/text_field.dart';
import 'package:touroll/styles/calendar.dart';

class NewActivityScreen extends StatefulWidget {
  final tourId;
  final days;
  NewActivityScreen({Key key, this.tourId, this.days}) : super(key: key);

  @override
  _NewActivityScreenState createState() => _NewActivityScreenState();
}

class _NewActivityScreenState extends State<NewActivityScreen> {
  bool creatingActivity = false;
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  final uploadService = UploadService();
  final activityService = ActivityService();
  bool uploadingImage = false;
  String image;
  File imageFile;

  int day = 1;
  TimeOfDay time;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final durationController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void selectImage() async {
    setState(() {
      uploadingImage = true;
    });
    try {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
      imageFile = File(pickedFile.path);
      //
      final id = await uploadService.upload(imageFile);
      setState(() {
        image = id;
      });
    } catch (ex) {
      print(ex.toString());
      imageFile = null;
      image = null;
    }
    setState(() {
      uploadingImage = false;
    });
  }

  Future<void> createActivity() async {
    final title = titleController.text;
    final description = descriptionController.text;
    final realTime = day * 1440 + time.hour * 60 + time.minute;
    int duration = num.tryParse(durationController.text);
    setState(() {
      creatingActivity = true;
    });
    try {
      Activity a = await activityService.createActivity(
          tourId: widget.tourId,
          title: title,
          description: description,
          time: realTime,
          image: image,
          duration: duration);
      Navigator.pop(context);
    } catch (ex) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context), child: Text('OK'))
              ],
              title: Text('Sorry...'),
              content: Text(
                  'There is something wrong when creating the activity. Probably it has conflict with an existing activity. Please check it and submit again.'),
            );
          });
    }
    setState(() {
      creatingActivity = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoginOnly(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: Text('New Activity'),
              ),
              body: Form(
                key: _formKey,
                child: CustomScrollView(shrinkWrap: true, slivers: [
                  SliverToBoxAdapter(
                    child: Container(
                      height: 240,
                      child: uploadingImage
                          ? Center(child: Loading())
                          : image == null
                              ? Container(
                                  child: Button(
                                      label: 'Upload image',
                                      onPressed: () => selectImage()),
                                )
                              : InkWell(
                                  child:
                                      Image.file(imageFile, fit: BoxFit.cover),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Dropdown(
                                  label: 'Day',
                                  value: day.toString(),
                                  values: List.generate(
                                      widget.days, (i) => (i + 1).toString()),
                                  onChanged: (s) {
                                    setState(() {
                                      day = num.tryParse(s);
                                    });
                                  }),
                              Container(
                                width: 12,
                              ),
                              TimePicker(
                                label: 'Time',
                                value: time,
                                validator: (s) {
                                  if (s == null || s.length == 0) {
                                    return 'Please specifiy time';
                                  }
                                  return null;
                                },
                                onChanged: (t) {
                                  setState(() {
                                    time = t;
                                  });
                                },
                              )
                            ],
                          ),
                          Container(
                            height: 12,
                          ),
                          CustomTextField(
                            form: true,
                            controller: durationController,
                            keyboardType: TextInputType.number,
                            label: 'Duration (Minutes)',
                            validator: (value) {
                              print(value);
                              if (value.trim().isEmpty) {
                                return 'Duration is required';
                              }
                              num n = num.tryParse(value);
                              if (n == null || n <= 0) {
                                return 'Invalid duration';
                              }
                              if (n > 1440) {
                                return 'Duration cannot be greater than 1440';
                              }
                            },
                          ),
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
                                  loading: creatingActivity,
                                  label: 'Create',
                                  onPressed: uploadingImage
                                      ? null
                                      : () {
                                          if (!_formKey.currentState
                                              .validate()) {
                                            return;
                                          }
                                          createActivity();
                                        }),
                            )),
                      ],
                    ),
                  ),
                ]),
              ),
            ));
  }
}
