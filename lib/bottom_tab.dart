import 'package:flutter/material.dart';
import 'package:mobile_app_final_project/state/application_state.dart';
import 'package:provider/provider.dart';
import './screen/home/home.dart';
import './screen/carpool/carpool_list.dart';
import './screen/my_page/profile.dart';

class BottomTab extends StatefulWidget {
  const BottomTab({Key? key,}) : super(key: key);

  @override
  State<BottomTab> createState() => _BottomTabState();
}

class _BottomTabState extends State<BottomTab> {
  int _currentIndex = 0;

  void _onTap(int index, ApplicationState appState) {
    appState.onTapBottomNavigation(index);
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<ApplicationState>(
      builder: (context, appState, _) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(appState.getTitle()),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.notifications,
                semanticLabel: 'filter',
              ),
              onPressed: () => appState.changePageIndex(1),
            ),
            IconButton(
              icon: const Icon(
                Icons.email_outlined,
                semanticLabel: 'filter',
              ),
              onPressed: () => appState.changePageIndex(2),
            ),
          ],
          backgroundColor: Colors.black,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: appState.getPage(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.directions_car_rounded), label: 'Carpool'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
          onTap: (index) => {
            _onTap(index, appState)
          },
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
        ),
      ),
    );
  }
}
