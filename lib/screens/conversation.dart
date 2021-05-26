import 'package:firebase_auth/firebase_auth.dart' as fa;
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:touroll/components/loading.dart';
import 'package:touroll/components/login_only.dart';
import 'package:touroll/components/route/slide.dart';
import 'package:touroll/screens/channel.dart';
import 'package:touroll/screens/channel_list.dart';
import 'package:touroll/services/auth.dart';
import 'package:touroll/services/user.dart';
import 'package:touroll/stream/client.dart';

class ConversationScreen extends StatefulWidget {
  ConversationScreen({Key key}) : super(key: key);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final authService = AuthService();
  final userService = UserService();
  Future<bool> connect;
  Channel selectedChannel;

  Future<bool> _connect() async {
    String uid = fa.FirebaseAuth.instance.currentUser?.uid;
    String name =
        fa.FirebaseAuth.instance.currentUser?.displayName ?? 'No name';
    String image = fa.FirebaseAuth.instance.currentUser?.photoURL;
    await streamClient.connectUserWithProvider(
        User(id: uid, extraData: {name: name, 'image': image}));
    return true;
  }

  @override
  void initState() {
    super.initState();
    connect = _connect();
  }

  @override
  Widget build(BuildContext context) {
    return LoginOnly(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Chats'),
          ),
          body: FutureBuilder(
              future: connect,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done)
                  return ChannelListPage(
                    onTap: (channel) {
                      setState(() {
                        selectedChannel = channel;
                        if (selectedChannel != null) {
                          Navigator.of(context, rootNavigator: true)
                              .push(SlideRoute(
                                  widget: ChannelPage(
                            channel: selectedChannel,
                          )));
                        }
                      });
                    },
                  );
                else
                  return Center(child: Loading());
              }),
        );
      },
    );
  }
}
