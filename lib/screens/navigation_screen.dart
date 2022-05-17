import 'package:assessment_app/screens/history_screen.dart';
import 'package:assessment_app/screens/home_screen.dart';
import 'package:flutter/material.dart';

class NavigationScreen extends StatefulWidget {
  static const routeName = '/navigation screen';

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  var currentIndex = 0;
  List<Widget> screens = [const MyHomeScreen(), const HistoryScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          elevation: 10,
          selectedItemColor: Colors.teal.shade600,
          unselectedItemColor: Colors.grey.shade600,
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  currentIndex == 0
                      ? Icons.person_search_rounded
                      : Icons.person_search_outlined,
                  size: 27,
                ),
                label: ''),
            const BottomNavigationBarItem(
                icon: Icon(
                  //Icons.play_for_work_outlined,
                  Icons.history_rounded,
                  size: 24,
                ),
                label: '')
          ]),
    );
  }
}
