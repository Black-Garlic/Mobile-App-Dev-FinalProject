import 'package:flutter/material.dart';
import '../screen/home/home.dart';
import '../screen/header/notification.dart';
import '../screen/header/chat_list.dart';
import '../screen/header/chat_room.dart';
import '../screen/carpool/carpool_list.dart';
import '../screen/carpool/carpool_apply.dart';
import '../screen/carpool/carpool_detail.dart';
import '../screen/my_page/profile.dart';
import '../screen/my_page/car_add.dart';

class ApplicationState extends ChangeNotifier {
  int _pageIndex = 0;
  int get pageIndex => _pageIndex;

  final List<Widget> _page = [
    const HomePage(),
    const NotificationPage(),
    const ChatListPage(),
    const ChatRoomPage(),
    const CarpoolListPage(),
    const CarpoolApplyPage(),
    const CarpoolDetailPage(),
    const ProfilePage(),
    const CarAddPage(),
  ];

  final List<String> _title = [
    'Home',
    'Notification',
    'Chat List',
    'Chat Room',
    'Carpool List',
    'Carpool Apply',
    'Carpool Detail',
    'Profile',
    'Car Add',
  ];

  ApplicationState();

  Widget getPage() {
    return _page[_pageIndex];
  }

  String getTitle() {
    return _title[_pageIndex];
  }

  void onTapBottomNavigation(int index) {
    switch(index) {
      case 0:
        changePageIndex(0);
        break;
      case 1:
        changePageIndex(4);
        break;
      case 2:
        changePageIndex(7);
        break;
    }
  }

  void changePageIndex(int index) {
    _pageIndex = index;
    notifyListeners();
  }
}