import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:touroll/screens/thread.dart';

class ChannelPage extends StatelessWidget {
  final Channel channel;
  const ChannelPage({Key key, this.channel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamChannel(
      key: ValueKey(channel.cid),
      child: Scaffold(
        appBar: ChannelHeader(),
        body: Column(
          children: <Widget>[
            Expanded(
              child: MessageListView(),
            ),
            MessageInput(
              showCommandsButton: false,
            ),
          ],
        ),
      ),
      channel: channel,
    );
  }
}
