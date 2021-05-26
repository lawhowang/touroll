import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:touroll/models/activity.dart';
import 'package:touroll/services/activity.dart';
import 'package:touroll/utils/time_converter.dart';

class ActivityBlock extends StatelessWidget {
  final activityService = ActivityService();
  final Activity activity;
  final int day;
  final bool showDay;
  final bool hasNext;
  final Future Function() onDelete;
  ActivityBlock(
      {Key key,
      @required this.activity,
      this.day = 0,
      this.hasNext = false,
      this.showDay = true,
      this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: showDay
                  ? Column(
                      children: [
                        Text(
                          'Day',
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 10),
                        ),
                        Padding(padding: EdgeInsets.only(top: 3)),
                        Text(
                          day.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                              color: Theme.of(context).accentColor),
                        ),
                        if (hasNext)
                          Expanded(
                            child: Container(
                              width: 1,
                              color: Theme.of(context).accentColor,
                            ),
                          )
                      ],
                    )
                  : Column(
                      children: [
                        Container(
                          height: 16,
                          width: 1,
                          color: Theme.of(context).accentColor,
                        ),
                        Container(
                          width: 10,
                          height: 10,
                          // margin: EdgeInsets.only(top: 24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                                width: 1, color: Theme.of(context).accentColor),
                          ),
                        ),
                        if (hasNext)
                          Expanded(
                            child: Container(
                              width: 1,
                              color: Theme.of(context).accentColor,
                            ),
                          )
                      ],
                    ),
            ),
            Container(
              width: 24,
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          TimeConverter.formatTime(activity.time) +
                              ' - ' +
                              TimeConverter.formatTime(
                                  activity.time + activity.duration),
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: Theme.of(context).accentColor),
                        ),
                        Container(
                          height: 3,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                activity?.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Container(
                              width: 12,
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 6)),
                        Text(
                          activity?.description,
                          style:
                              TextStyle(color: Color(0xff8e8e8e), fontSize: 12),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 32),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            if (onDelete != null)
              IconButton(
                  icon: Icon(Icons.delete, color: Colors.black26),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Warning'),
                            content: Text(
                                'Are you sure to you want to delete this activity?'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cancel')),
                              TextButton(
                                  onPressed: () {
                                    try {
                                      onDelete().then((value) {
                                        Navigator.pop(context);
                                      }).catchError((onError) {
                                        Navigator.pop(context);
                                      });
                                    } catch (ex) {}
                                  },
                                  child: Text('Yes, delete it'))
                            ],
                          );
                        });
                  })
          ],
        ),
      ),
    );
  }
}
