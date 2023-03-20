import 'package:flutter/material.dart';

class CardScreen extends StatelessWidget {
  final Widget child;

  const CardScreen({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          height: 400,
          decoration: decorationBox(),
          child: child),
    );
  }

  BoxDecoration decorationBox() {
    return BoxDecoration(
      boxShadow: const <BoxShadow>[
        BoxShadow(
          color: Colors.black12,
          blurRadius: 15,
          offset: Offset(0, 5),
        ),
      ],
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
    );
  }
}
