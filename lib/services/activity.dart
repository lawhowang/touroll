import 'package:flutter/widgets.dart';
import 'package:touroll/models/activity.dart';
import 'package:touroll/models/point.dart';
import 'package:touroll/utils/http.dart';

class ActivityService {
  Future<Activity> getActivity(int id) async {
    final activity = await HttpUtils.getData('activities/$id');
    return Activity.fromJson(activity);
  }

  //
  Future<Activity> createActivity(
      {@required String title,
      @required String description,
      @required int tourId,
      @required int time,
      @required int duration,
      String image,
      Point location}) async {
    final createdActivity = await HttpUtils.postData('activities', {
      'title': title,
      'description': description,
      'tourId': tourId,
      'time': time,
      'duration': duration,
      'image': image,
      'location': location
    });
    return Activity.fromJson(createdActivity);
  }

  Future<Activity> updateActivity(int id,
      {String title,
      String description,
      int tourId,
      int time,
      int duration,
      Point location}) async {
    Activity updatedActivity = await HttpUtils.patchData('activities/$id', {
      'title': title,
      'description': description,
      'tourId': tourId,
      'time': time,
      'duration': duration,
      'location': location
    });
    return updatedActivity;
  }

  Future<bool> deleteActivity(int id) async {
    await HttpUtils.deleteData('activities/$id');
    return true;
  }
}
