import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Container(
        constraints: BoxConstraints(minWidth: 120),
        child: Image.asset(
          'lib/assets/images/logo.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}