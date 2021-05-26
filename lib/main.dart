import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' as stream;
//import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:touroll/screens/account.dart';
import 'package:touroll/screens/conversation.dart';
import 'package:touroll/components/loading.dart';
import 'package:touroll/components/scroll_behavior.dart';
import 'package:touroll/screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:touroll/screens/discover.dart';
import 'package:touroll/screens/me/my_reservation.dart';
import 'package:touroll/screens/tour.dart';
import 'package:touroll/stream/client.dart';
import 'package:google_fonts/google_fonts.dart';

final Future<FirebaseApp> _initialization = Firebase.initializeApp();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Touroll',
    theme: ThemeData(
      //brightness: Brightness.dark,
      splashColor: Colors.transparent,
      primaryColor: Color(0xFFED9B4A),
      accentColor: Color(0xFF8C403F),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Color(0xFFFFBA76),
        selectionColor: Color(0xFFFFBA76),
        selectionHandleColor: Color(0xFFED9B4A),
      ),
      appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          titleSpacing: 0,
          textTheme: TextTheme(
            headline6: TextStyle(color: Colors.black87, fontSize: 18),
          )),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(primary: Color(0xFFD97C02)),
      ),
      textTheme: GoogleFonts.poppinsTextTheme(),
    ),
    builder: (context, child) {
      return ScrollConfiguration(
        behavior: CustomScrollBehavior(),
        child: stream.StreamChat(
          child: child,
          client: streamClient,
          streamChatThemeData: stream.StreamChatThemeData(
              colorTheme: stream.ColorTheme.light(
                  accentBlue: Color(0xFF8C403F),
                  accentGreen: Color(0xFF8C403F),
                  accentRed: Color(0xFF8C403F))),
        ),
      );
    },
    home: DefaultTextStyle(
      style: TextStyle(color: Color(0xFFD97C02)),
      child: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          print(Theme.of(context).accentColor);
          if (snapshot.connectionState == ConnectionState.done) {
            return MyHomePage(title: 'Touroll');
          }
          return Loading();
        },
      ),
    ),
  ));
}

// class MyApp extends StatelessWidget {
//   final Future<FirebaseApp> _initialization = Firebase.initializeApp();
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: _initialization,
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return Loading();
//         }
//         if (snapshot.connectionState == ConnectionState.done) {
//           return LoginScreen();
//         }
//         return Loading();
//       },
//     );
//   }
// }

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  final heroController = HeroController();
  int _selectedIndex = 0;

  final _discoverScreen = GlobalKey<NavigatorState>();
  final _tripsScreen = GlobalKey<NavigatorState>();
  final _conversationsScreen = GlobalKey<NavigatorState>();
  final _accountScreen = GlobalKey<NavigatorState>();

  void _onTap(int val, BuildContext context) {
    if (_selectedIndex == val) {
      switch (val) {
        case 0:
          _discoverScreen.currentState.popUntil((route) => route.isFirst);
          break;
        case 1:
          _tripsScreen.currentState.popUntil((route) => route.isFirst);
          break;
        case 2:
          _conversationsScreen.currentState.popUntil((route) => route.isFirst);
          break;
        case 3:
          _accountScreen.currentState.popUntil((route) => route.isFirst);
          break;
        default:
      }
    } else {
      if (mounted) {
        setState(() {
          _selectedIndex = val;
        });
      }
    }
  }

  @override
  void initState() {
    // _controller = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Widget homeFilled = SvgPicture.asset(
      'assets/svg/filled/home.svg',
      semanticsLabel: 'Home',
      color: Theme.of(context).primaryColor,
      width: 24,
      height: 24,
    );

    final Widget homeOutline = SvgPicture.asset(
      'assets/svg/outline/home.svg',
      semanticsLabel: 'Home',
      color: Colors.black38,
      width: 24,
      height: 24,
    );

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          Navigator(
            observers: [heroController],
            key: _discoverScreen,
            onGenerateRoute: (route) => MaterialPageRoute(
              settings: route,
              builder: (context) => Discover(),
            ),
          ),
          Navigator(
            key: _tripsScreen,
            onGenerateRoute: (route) => MaterialPageRoute(
              settings: route,
              builder: (context) => MyReservationsScreen(),
            ),
          ),
          Navigator(
            key: _conversationsScreen,
            onGenerateRoute: (route) => MaterialPageRoute(
              settings: route,
              builder: (context) => ConversationScreen(),
            ),
          ),
          Navigator(
            key: _accountScreen,
            onGenerateRoute: (route) => MaterialPageRoute(
              settings: route,
              builder: (context) => AccountScreen(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Hero(
        tag: 'navigation-bar',
        child: Material(
          type: MaterialType.transparency,
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            elevation: 1,
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            onTap: (val) => _onTap(val, context),
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: homeOutline,
                activeIcon: homeFilled,
                label: 'Discover',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.card_travel),
                label: 'Trips',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat),
                label: 'Chats',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
            unselectedItemColor: Colors.black38,
          ),
        ),
      ),
    );
  }
}
