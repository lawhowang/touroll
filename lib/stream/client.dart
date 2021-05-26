import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:touroll/utils/http.dart';

Future<String> _getChatToken(firebaseUid) async {
  if (firebaseUid == null) {
    throw new Exception("Firebase uid is null");
  }
  final response = await HttpUtils.getData("chat/token");
  final chatToken = response['token'];
  if (chatToken == null) {
    throw new Exception("Firebase uid is null");
  }
  return chatToken;
}

final streamClient =
    StreamChatClient('', logLevel: Level.OFF, tokenProvider: _getChatToken);
