import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _BoxBackground(),
        _IconLogin(),
        child,
      ],
    );
  }
}

class _IconLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 40),
        alignment: Alignment.topCenter,
        child: const Icon(
          Icons.person_pin,
          color: Colors.white,
          size: 100,
        ),
      ),
    );
  }
}

class _BoxBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height * 0.4,
      decoration: purpleBox(),
      child: Stack(
        children: [
          Positioned(child: _BubblePurple(), top: 10, left: 10),
          Positioned(child: _BubblePurple(), bottom: -40, left: -20),
          Positioned(child: _BubblePurple(), bottom: 50, right: 10),
          Positioned(child: _BubblePurple(), right: 10, top: 90),
          Positioned(child: _BubblePurple(), top: 150, left: 80),
        ],
      ),
    );
  }

  BoxDecoration purpleBox() {
    return const BoxDecoration(
        gradient: LinearGradient(colors: [
      Color.fromRGBO(63, 63, 156, 1),
      Color.fromRGBO(90, 70, 178, 1),
    ]));
  }
}

class _BubblePurple extends StatelessWidget {
  const _BubblePurple({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.deepPurple,
      ),
    );
  }
}
