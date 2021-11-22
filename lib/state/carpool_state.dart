import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile_app_final_project/model/carpool.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/carpool.dart';
import '../model/notification.dart';
import '../model/chat.dart';
import '../model/car.dart';

class CarpoolState extends ChangeNotifier {

  StreamSubscription<QuerySnapshot>? _carpoolSubscription;
  List<Carpool> _carpool = [];
  List<Carpool> get carpool => _carpool;

  StreamSubscription<QuerySnapshot>? _notificationSubscription;
  List<Notifications> _notification = [];
  List<Notifications> get notification => _notification;

  StreamSubscription<QuerySnapshot>? _chatSubscription;
  List<Chat> _chat = [];
  List<Chat> get chat => _chat;

  StreamSubscription<QuerySnapshot>? _carSubscription;
  List<Car> _car = [];
  List<Car> get car => _car;

  CarpoolState() {
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp();

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        initStream();
      }
      notifyListeners();
    });
  }

  void initStream() {
    _carpoolSubscription = FirebaseFirestore.instance
        .collection('carpool')
        .orderBy('reg_date')
        .snapshots()
        .listen((snapshot) {
      _carpool = [];
      for (final document in snapshot.docs) {
        _carpool.add(
          Carpool(
            id: document.id,
            userUid: document.data()['user_uid'] as String,
            carUid: document.data()['car_uid'] as String,
            startLocation: document.data()['start_location'] as String,
            startLocationDetail: document.data()['start_location_detail'] as String,
            endLocation: document.data()['end_location'] as String,
            endLocationDetail: document.data()['end_location_detail'] as String,
            downtown: document.data()['downtown'] as bool,
            maxNum: document.data()['max_num'] as int,
            currentNum: document.data()['current_num'] as int,
            fee: document.data()['fee'] as int,
            regular: document.data()['regular'] as bool,
            departureTime: document.data()['departure_time'].toDate() as DateTime,
            memo: document.data()['memo'] as String,
            regDate: document.data()['reg_date'].toDate() as DateTime,
            modDate: document.data()['mod_date'].toDate() as DateTime,
          ),
        );
      }
    });
    _notificationSubscription = FirebaseFirestore.instance
        .collection('notificaiton')
        .orderBy('price')
        .snapshots()
        .listen((snapshot) {
      _notification = [];
      for (final document in snapshot.docs) {
        _notification.add(
          Notifications(
            id: document.id,
            userUid: document.data()['user_uid'] as String,
            message: document.data()['message'] as String,
            regDate: document.data()['reg_date'].toDate() as DateTime,
            modDate: document.data()['mod_date'].toDate() as DateTime,
          ),
        );
      }
    });
    _chatSubscription = FirebaseFirestore.instance
        .collection('product')
        .orderBy('price')
        .snapshots()
        .listen((snapshot) {
      _chat = [];
      for (final document in snapshot.docs) {
        _chat.add(
          Chat(
            id: document.id,
            userUid: document.data()['user_uid'] as String,
            carpoolUid: document.data()['carpool_uid'] as String,
            message: document.data()['message'] as String,
            regDate: document.data()['reg_date'].toDate() as DateTime,
            modDate: document.data()['mod_date'].toDate() as DateTime,
          ),
        );
      }
    });
    _carSubscription = FirebaseFirestore.instance
        .collection('product')
        .orderBy('price')
        .snapshots()
        .listen((snapshot) {
      _car = [];
      for (final document in snapshot.docs) {
        _car.add(
          Car(
            id: document.id,
            userUid: document.data()['user_uid'] as String,
            car: document.data()['car'] as String,
            desc: document.data()['desc'] as String,
            regDate: document.data()['reg_date'].toDate() as DateTime,
            modDate: document.data()['mod_date'].toDate() as DateTime,
          ),
        );
      }
    });
    notifyListeners();
  }

  ListView buildCarpoolListView(BuildContext context) {
    return ListView.builder(
      itemCount: _carpool.length,
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (BuildContext context, int index){
        return Card(
          clipBehavior: Clip.antiAlias,
          child: ListTile(
            contentPadding: const EdgeInsets.all(10.0),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(_carpool[index].regular ? '정기 카풀' : '단발성 카풀'),
                    ),
                    Text(_carpool[index].fee.toString() + '원 - '),
                    Text(_carpool[index].currentNum.toString() + ' / ' + _carpool[index].maxNum.toString()),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(_carpool[index].startLocation),
                          Text(_carpool[index].startLocationDetail),
                        ],
                      )
                    ),
                    Text(_carpool[index].fee.toString() + '원 - '),
                    Expanded(
                      child: Column(
                        children: [
                          Text(_carpool[index].endLocation),
                          Text(_carpool[index].endLocationDetail),
                        ],
                      )
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(_carpool[index].departureTime.toString()),
                    ),
                  ],
                ),
              ]
            ),
          ),
        );
      },
    );
  }
}