import 'package:flutter/material.dart';
import 'package:mobile_app_final_project/state/application_state.dart';
import 'package:provider/provider.dart';

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
          leading: appState.backButton ?
            IconButton(
              onPressed: () => appState.changePageIndex(appState.backButtonIndex),
              icon: const Icon(Icons.arrow_back_ios),
            )
            :
            Text(""),
          title: Text(appState.getTitle()),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.mail_outline,
                semanticLabel: 'filter',
              ),
              onPressed: () => appState.changePageIndex(2),
            ),
          ],
          backgroundColor: Colors.black,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: appState.getPage(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: '카풀'),
            BottomNavigationBarItem(icon: Icon(Icons.directions_car_rounded), label: '카풀 등록'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: '프로필'),
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
