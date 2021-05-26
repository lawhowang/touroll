import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:touroll/components/button.dart';
import 'package:touroll/components/route/fade.dart';
import 'package:touroll/screens/me/my_reservation.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({Key key}) : super(key: key);

  @override
  _SuccessScreenState createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: Lottie.asset(
                'assets/lottie/success.json',
                controller: _controller,
                onLoaded: (composition) {
                  // Configure the AnimationController with the duration of the
                  // Lottie file and start the animation.
                  _controller
                    ..duration = composition.duration
                    ..forward();
                },
              ),
            ),
            // Animation container
            //
            Transform.translate(
              offset: Offset(0, -60),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Congratulations!',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24)),
                    Container(
                      height: 12,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                                'You have successfully reserved the trip.',
                                style: TextStyle(
                                    fontWeight: FontWeight.w200, fontSize: 16)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  width: 60,
                ),
                Expanded(
                    child: Button(
                  label: 'View my reservation',
                  // loading: reserving,
                  backgroundColor: Colors.black12,
                  onPressed: () async {
                    Navigator.of(
                      context,
                    ).pop();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => MyReservationsScreen()),
                      (route) => route.isFirst,
                    );
                    // Navigator.of(context, rootNavigator: false)
                    //     .push(FadeRoute(widget: MyReservationsScreen()));
                  },
                )),
                Container(
                  width: 60,
                )
              ],
            ),
            Container(
              height: 24,
            ),
            // Row(
            //   children: [
            //     Container(
            //       width: 60,
            //     ),
            //     Expanded(
            //         child: GestureDetector(
            //             onTap: () {
            //               Navigator.of(context).popUntil((route) => route.isFirst);
            //             },
            //             child: Center(child: Text('Back to Home')))),
            //     Container(
            //       width: 60,
            //     )
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
