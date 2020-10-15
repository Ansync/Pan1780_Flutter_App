import 'package:flutter/material.dart';
import 'state.dart';

var state = MyState();

class PanLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(state.deviceHeight * 0.05),
          child: Image.asset(
            'assets/panlogo.png',
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/futurelogo.png',
                height: state.deviceHeight * 0.06)
          ],
        )
      ],
    );
  }
}
