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
  int _pageIndex = 4;
  int get pageIndex => _pageIndex;

  final List<Widget> _page = [
    const CarpoolListPage(),
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
    '내 카풀',
    '알림',
    '채팅 목록',
    '채팅방',
    '카풀 목록',
    '카풀 등록',
    '카풀 정보',
    '프로필',
    '차량 등록',
  ];

  bool _backButton = false;
  bool get backButton => _backButton;

  int _backButtonIndex = 0;
  int get backButtonIndex => _backButtonIndex;

  bool _editPage = false;
  bool get editPage => _editPage;

  int _editCarpoolIndex = 0;
  int get editCarpoolIndex => _editCarpoolIndex;

  int _editCarIndex = 0;
  int get editCarIndex => _editCarIndex;

  ApplicationState();

  Widget getPage() {
    return _page[_pageIndex];
  }

  String getTitle() {
    return _title[_pageIndex];
  }

  void setChatRoomTitle(String carpool) {
    _title[3] = carpool;
  }

  void setTabTitle(String title, int index) {
    _title[index] = title;
  }

  void onTapBottomNavigation(int index) {
    switch(index) {
      case 0:
        resetEditInformation();
        changePageIndex(4);
        break;
      case 1:
        resetEditInformation();
        setTabTitle("카풀 등록", 5);
        changePageIndex(5);
        break;
      case 2:
        resetEditInformation();
        changePageIndex(7);
        break;
    }
  }

  void changePageIndex(int index) {
    _pageIndex = index;
    if (index == 3) {
      _backButton = true;
      _backButtonIndex = 2;
    } else if (index == 6) {
      _backButton = true;
      _backButtonIndex = 4;
    } else if (index == 8) {
      _backButton = true;
      _backButtonIndex = 7;
    } else {
      _backButton = false;
    }
    notifyListeners();
  }

  void resetEditInformation() {
    _editPage = false;
    _editCarpoolIndex = 0;
    _editCarIndex = 0;
  }

  void setEditInformation(bool carpool, int index) {
    if (carpool) {
      _editCarpoolIndex = index;
    } else {
      _editCarIndex = index;
    }
    _editPage = true;
  }
}