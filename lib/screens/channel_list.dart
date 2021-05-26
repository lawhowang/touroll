import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChannelListPage extends StatelessWidget {
  final void Function(Channel) onTap;

  ChannelListPage({this.onTap});

  @override
  Widget build(BuildContext context) {
    return ChannelsBloc(
      child: ChannelListView(
        onChannelTap: onTap != null
            ? (channel, _) {
                onTap(channel);
              }
            : null,
        filter: {
          'members': {
            '\$in': [StreamChat.of(context).user.id],
          }
        },
        sort: [SortOption('last_message_at')],
        pagination: PaginationParams(
          limit: 20,
        ),
        emptyBuilder: (_) => Center(child: Text('No conversation yet.')),
      ),
    );
  }
}
