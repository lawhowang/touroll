import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:touroll/models/tour.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:touroll/utils/image.dart';

class DetailsScreen extends StatefulWidget {
  final Tour tour;
  DetailsScreen({Key key, this.tour}) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool _showFrontSide = false;
  bool _flipXAxis = false;

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    print(widget.tour);
    _showFrontSide = true;
    _flipXAxis = true;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(),
        //   actions: [
        //     IconButton(
        //       icon: RotatedBox(
        //         child: Icon(Icons.flip),
        //         quarterTurns: _flipXAxis ? 0 : 1,
        //       ),
        //       onPressed: _changeRotationAxis,
        //     ),
        //   ],
        // ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Details',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Container(
                height: 12,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 120,
                    width: 120,
                    // decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CachedNetworkImage(
                        imageUrl: ImageUtil.getImageUrlByIdentifier(
                            ImageType.TOUR_COVER, widget.tour?.coverImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    width: 24,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(widget.tour.title,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w200)),
                        ),
                        Container(
                          height: 9,
                        ),
                        Container(
                          child: Text(widget.tour.description.toString(),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w200)),
                        ),
                         Container(
                          height: 9,
                        ),
                        Container(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(widget.tour.days.toString()+' days',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w200)),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),

              // Container(
              //   // decoration: BoxDecoration(color: Color(0xfff3f3f3)),
              //   child: CreditCardWidget(
              //     cardBgColor: Colors.lightBlue.shade500,
              //     cardNumber: cardNumber,
              //     expiryDate: expiryDate,
              //     cardHolderName: cardHolderName,
              //     cvvCode: cvvCode,
              //     showBackView:
              //         isCvvFocused, //true when you want to show cvv(back) view
              //   ),
              // ),
              // CreditCardForm(
              //   formKey: formKey, // Required
              //   onCreditCardModelChange: (CreditCardModel data) {
              //     setState(() {
              //       isCvvFocused = data.isCvvFocused;
              //       cardNumber = data.cardNumber;
              //       cvvCode = data.cvvCode;
              //       cardHolderName = data.cardHolderName;
              //       expiryDate = data.expiryDate;
              //     });
              //   }, // Required
              //   themeColor: Colors.red,
              //   obscureCvv: true,
              //   obscureNumber: true,
              //   cardNumber: cardNumber,
              //   expiryDate: expiryDate,
              //   cardHolderName: cardHolderName,
              //   cvvCode: cvvCode,
              //   cardNumberDecoration: const InputDecoration(
              //     // border: OutlineInputBorder(),
              //     labelText: 'Number',
              //     hintText: 'XXXX XXXX XXXX XXXX',
              //   ),
              //   expiryDateDecoration: const InputDecoration(
              //     // border: OutlineInputBorder(),
              //     labelText: 'Expired Date',
              //     hintText: 'XX/XX',
              //   ),
              //   cvvCodeDecoration: const InputDecoration(
              //     // border: OutlineInputBorder(),
              //     labelText: 'CVV',
              //     hintText: 'XXX',
              //   ),
              //   cardHolderDecoration: const InputDecoration(
              //     // border: OutlineInputBorder(),
              //     labelText: 'Card Holder',
              //   ),
              // ),
            ],
          ),
        ));
  }

  // void _changeRotationAxis() {
  //   setState(() {
  //     _flipXAxis = !_flipXAxis;
  //   });
  // }

  // void _switchCard() {
  //   setState(() {
  //     _showFrontSide = !_showFrontSide;
  //   });
  // }

  // Widget _buildFlipAnimation({double fullWidth, double fullHeight}) {
  //   double width = fullWidth * 0.8;
  //   // double height = 500;
  //   return GestureDetector(
  //     onTap: _switchCard,
  //     child: AnimatedSwitcher(
  //       duration: Duration(milliseconds: 600),
  //       transitionBuilder: __transitionBuilder,
  //       layoutBuilder: (widget, list) => Stack(children: [widget, ...list]),
  //       child: _showFrontSide
  //           ? _buildFront(
  //               width: width,
  //             )
  //           : _buildRear(
  //               width: width,
  //             ),
  //       switchInCurve: Curves.easeInBack,
  //       switchOutCurve: Curves.easeInBack.flipped,
  //     ),
  //   );
  // }

  // Widget __transitionBuilder(Widget widget, Animation<double> animation) {
  //   final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
  //   return AnimatedBuilder(
  //     animation: rotateAnim,
  //     child: widget,
  //     builder: (context, widget) {
  //       final isUnder = (ValueKey(_showFrontSide) != widget.key);
  //       var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
  //       tilt *= isUnder ? -1.0 : 1.0;
  //       final value =
  //           isUnder ? min(rotateAnim.value, pi / 2) : rotateAnim.value;
  //       return Transform(
  //         transform: _flipXAxis
  //             ? (Matrix4.rotationY(value)..setEntry(3, 0, tilt))
  //             : (Matrix4.rotationX(value)..setEntry(3, 1, tilt)),
  //         child: widget,
  //         alignment: Alignment.center,
  //       );
  //     },
  //   );
  // }

  // Widget _buildFront({double height, double width}) {
  //   return __buildLayout(
  //     key: ValueKey(true),
  //     width: width,
  //     backgroundColor: Colors.blue,
  //     faceName: "Dront",
  //     child: Padding(
  //       padding: EdgeInsets.all(32.0),
  //       child: ColorFiltered(
  //         colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcATop),
  //         child: FlutterLogo(),
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildRear({double height, double width}) {
  //   return __buildLayout(
  //     key: ValueKey(false),
  //     width: width,
  //     backgroundColor: Colors.blue.shade700,
  //     faceName: "Rear",
  //     child: Padding(
  //       padding: EdgeInsets.all(20.0),
  //       child: ColorFiltered(
  //         colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcATop),
  //         child:
  //             Center(child: Text("Flutter", style: TextStyle(fontSize: 50.0))),
  //       ),
  //     ),
  //   );
  // }

  // Widget __buildLayout({
  //   Key key,
  //   Widget child,
  //   String faceName,
  //   Color backgroundColor,
  //   double width,
  //   double height,
  // }) {
  //   return Container(
  //       margin: EdgeInsets.all(24),
  //       padding: EdgeInsets.all(24),
  //       key: key,
  //       decoration: BoxDecoration(
  //           shape: BoxShape.rectangle,
  //           borderRadius: BorderRadius.circular(20.0),
  //           color: Colors.lightBlue,
  //           boxShadow: [
  //             BoxShadow(
  //                 offset: Offset(0, 3),
  //                 spreadRadius: 3,
  //                 blurRadius: 6,
  //                 color: Colors.grey.withOpacity(0.3))
  //           ]),
  //       child: Container(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Row(
  //               children: [
  //                 Container(
  //                   height: 60,
  //                 )
  //               ],
  //             ),
  //             Column(
  //               children: [
  //                 Row(
  //                   children: [
  //                     Text('****', style: TextStyle(fontSize: 24)),
  //                     Container(
  //                       width: 12,
  //                     ),
  //                     Text('****', style: TextStyle(fontSize: 24)),
  //                     Container(
  //                       width: 12,
  //                     ),
  //                     Text('****', style: TextStyle(fontSize: 24)),
  //                     Container(
  //                       width: 12,
  //                     ),
  //                     Text('****', style: TextStyle(fontSize: 24)),
  //                   ],
  //                 ),
  //                 Row(
  //                   children: [
  //                     Text('MM/YY',
  //                         style: TextStyle(
  //                             fontSize: 16, fontWeight: FontWeight.bold)),
  //                     Text('MM/YY',
  //                         style: TextStyle(
  //                             fontSize: 16, fontWeight: FontWeight.bold)),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ));
  //   // return Container(
  //   //   key: key,
  //   //   decoration: BoxDecoration(
  //   //     color: backgroundColor,
  //   //     borderRadius: BorderRadius.circular(12.0),
  //   //   ),
  //   //   child: Stack(
  //   //     fit: StackFit.expand,
  //   //     children: [
  //   //       child,
  //   //       Positioned(
  //   //         bottom: 8.0,
  //   //         right: 8.0,
  //   //         child: Text(faceName),
  //   //       ),
  //   //     ],
  //   //   ),
  //   // );

}
