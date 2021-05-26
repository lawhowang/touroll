import 'package:firebase_auth/firebase_auth.dart' as fa;
import 'package:touroll/models/reservation.dart';
import 'package:touroll/models/tour.dart';
import 'package:touroll/models/user.dart';
import 'package:touroll/stream/client.dart' as client;
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart'
    as streamCore;
import 'package:touroll/utils/http.dart';
import 'package:touroll/utils/image.dart';

class UserService {
  Future<void> _updateRelatedServices(User user) async {
    String iconUrl;
    if (user.icon != null) {
      iconUrl =
          ImageUtil.getImageUrlByIdentifier(ImageType.USER_ICON, user.icon);
    }
    await fa.FirebaseAuth.instance.currentUser
        .updateProfile(photoURL: iconUrl, displayName: user.name ?? 'No name');
    final streamParams = <String, dynamic>{};
    if (user.name != null) {
      streamParams['name'] = user.name;
    }
    if (iconUrl != null) {
      streamParams['image'] = iconUrl;
    }
    client.streamClient.updateUser(streamCore.User(
        id: fa.FirebaseAuth.instance.currentUser.uid, extraData: streamParams));
  }

  Future<User> getProfile() async {
    final res = await HttpUtils.getData('users/me');
    final user = User.fromJson(res);
    _updateRelatedServices(user);
    return user;
  }

  Future<User> updateMe({String icon, String name, String about}) async {
    final params = <String, String>{};
    if (icon != null) {
      params['icon'] = icon;
    }
    if (name != null) {
      params['name'] = name;
    }
    if (about != null) {
      params['about'] = about;
    }
    final res = await HttpUtils.patchData('users/me', params);
    final user = User.fromJson(res);
    await _updateRelatedServices(user);
    return user;
  }

  Future<List<Reservation>> getReservations(
      {int after,
      int limit = 10,
      bool desc = false,
      String orderBy = 'startDate',
      List<String> expand}) async {
    Iterable reservations = await HttpUtils.getData('users/me/reservations', {
      'after': after,
      'limit': limit,
      'orderBy': orderBy,
      'desc': desc,
      'expand': expand
    });
    return reservations.map((a) => Reservation.fromJson(a)).toList();
  }

  Future<void> updatePassword(String password) async {
    await fa.FirebaseAuth.instance.currentUser.updatePassword(password);
  }

  Future<List<Tour>> getTours(
      {int after,
      int limit = 10,
      bool desc = true,
      String orderBy = 'id'}) async {
    Iterable tours = await HttpUtils.getData('users/me/tours',
        {'after': after, 'limit': limit, 'orderBy': orderBy, 'desc': desc});
    return tours.map((a) => Tour.fromJson(a)).toList();
  }
}
