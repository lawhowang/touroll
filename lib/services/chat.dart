import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:touroll/models/activity.dart';
import 'package:touroll/models/point.dart';
import 'package:touroll/stream/client.dart';
import 'package:touroll/utils/http.dart';

class ChatService {
  Future<Channel> newChat(String userId) async {
    final response = await HttpUtils.postData('chat/new', {'userId': userId});

    final channelId = response['channelId'];
    return streamClient.channel('messaging', id: channelId);
  }
}
