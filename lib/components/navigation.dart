import 'package:flutter/material.dart';

class CustomNavigation extends StatelessWidget {
  const CustomNavigation({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return BottomAppBar(
      child: Hero(
        tag: 'bottomAppBar',
        child: Material(
          child: Row(children: [
            Container(height: 30,width: 30,color: Colors.black,)
          ],),
        ),
      ),
    );
// Container(
//       color: Colors.white10,
//       width: screenWidth,
//       height: 80,
//       child: Row(
//         children: [],
//       ),
//     );
  }
}
