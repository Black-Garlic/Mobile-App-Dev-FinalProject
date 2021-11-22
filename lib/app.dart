import 'package:flutter/material.dart';

import './screen/home/home.dart';
import './screen/home/login.dart';
import './screen/home/sign_up.dart';
import './screen/header/notification.dart';
import './screen/header/chat_list.dart';
import './screen/header/chat_room.dart';
import './screen/carpool/carpool_list.dart';
import './screen/carpool/carpool_apply.dart';
import './screen/carpool/carpool_detail.dart';
import './screen/my_page/profile.dart';
import './screen/my_page/car_add.dart';
import 'bottom_tab.dart';


class CarpoolApp extends StatelessWidget {
  const CarpoolApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shrine',
      home: const BottomTab(),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/sign_up': (context) => const SignUpPage(),
        '/home' : (context) => const HomePage(),
        '/notification': (context) => const NotificationPage(),
        '/chat_list': (context) => const ChatListPage(),
        '/chat_room': (context) => const ChatRoomPage(),
        '/carpool_list': (context) => const CarpoolListPage(),
        '/carpool_apply': (context) => const CarpoolApplyPage(),
        '/carpool_detail': (context) => const CarpoolDetailPage(),
        '/profile': (context) => const ProfilePage(),
        '/car_add': (context) => const CarAddPage(),
      },
    );
  }

  Route<dynamic>? _getRoute(RouteSettings settings) {
    if (settings.name != '/login') {
      return null;
    }

    return MaterialPageRoute<void>(
      settings: settings,
      builder: (BuildContext context) => const LoginPage(),
      fullscreenDialog: true,
    );
  }
}
