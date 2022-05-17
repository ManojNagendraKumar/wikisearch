import 'dart:async';

import 'package:assessment_app/screens/navigation_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //It manages the duration and the function to be displayed
  void _timer() {
    Timer(const Duration(seconds: 3), () async {
      await Navigator.of(context)
          .pushReplacementNamed(NavigationScreen.routeName);
    });
  }

  @override
  void initState() {
    super.initState();
    _timer();
  }

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.youtube_searched_for_rounded,
              size: 30,
              color: Colors.black,
            ),
            SizedBox(
              height: _size.height * 0.02,
            ),
            Text(
              'Wikisearch',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Colors.teal.shade600),
            )
          ],
        ),
      ),
    );
  }
}
