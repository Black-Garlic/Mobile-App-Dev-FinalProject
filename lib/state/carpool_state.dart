import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile_app_final_project/model/carpool.dart';
import 'package:mobile_app_final_project/state/application_state.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/carpool.dart';
import '../model/notification.dart';
import '../model/chat.dart';
import '../model/car.dart';
import '../model/participate.dart';

class CarpoolState extends ChangeNotifier {

  StreamSubscription<QuerySnapshot>? _carpoolSubscription;
  List<Carpool> _carpool = [];
  List<Carpool> get carpool => _carpool;

  StreamSubscription<QuerySnapshot>? _myCarpoolSubscription;
  List<Parcitipate> _myCarpool = [];
  List<Parcitipate> get myCarpool => _myCarpool;

  StreamSubscription<QuerySnapshot>? _notificationSubscription;
  List<Notifications> _notification = [];
  List<Notifications> get notification => _notification;

  StreamSubscription<QuerySnapshot>? _chatSubscription;
  List<Chat> _chat = [];
  List<Chat> get chat => _chat;

  StreamSubscription<QuerySnapshot>? _carSubscription;
  List<Car> _car = [];
  List<Car> get car => _car;

  late Carpool _selectedCarpool;
  Carpool get selectedCarpool => _selectedCarpool;

  CarpoolState() {
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp();

    FirebaseAuth.instance.userChanges().listen((user) {
      print("change user");
      if (user != null) {
        initStream();
      }
      notifyListeners();
    });
  }

  void initStream() {
    _carpoolSubscription = FirebaseFirestore.instance
        .collection('carpool')
        .orderBy('reg_date', descending: true)
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
    _myCarpoolSubscription = FirebaseFirestore.instance
        .collection('participate')
        .where('user_uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .orderBy('reg_date')
        .snapshots()
        .listen((snapshot) {
      _myCarpool = [];
      for (final document in snapshot.docs) {
        print("MyCarpool");
        _myCarpool.add(
          Parcitipate(
            id: document.id,
            userUid: document.data()['user_uid'] as String,
            carpoolUid: document.data()['car_uid'] as String,
            send: document.data()['send'] as bool,
            regDate: document.data()['reg_date'].toDate() as DateTime,
            modDate: document.data()['mod_date'].toDate() as DateTime,
          ),
        );
      }
    });
    _notificationSubscription = FirebaseFirestore.instance
        .collection('notification')
        .where('user_uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .orderBy('reg_date')
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
        .collection('chat')
        .where('user_uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .orderBy('reg_date')
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
        .collection('car')
        .where('user_uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .orderBy('reg_date')
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

  ListView buildCarpoolListView(BuildContext context, bool myCarpool) {
    List<Carpool> carpoolList = [];

    if (myCarpool) {
      for (Parcitipate participate in _myCarpool) {
        for (Carpool carpool in _carpool) {
          if (participate.carpoolUid == carpool.id) {
            carpoolList.add(carpool);
          }
        }
      }
    } else {
      carpoolList = _carpool;
    }

    return ListView.builder(
      itemCount: _carpool.length,
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (BuildContext context, int index) {
        return Card(
          clipBehavior: Clip.antiAlias,
          child: Consumer<ApplicationState>(
            builder: (context, appState, _) => ListTile(
              contentPadding: const EdgeInsets.all(10.0),
              onTap: () => {
                _selectedCarpool = carpoolList[index],
                appState.changePageIndex(6),
              },
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
                      Text(_carpool[index].fee.toString() + '원'),
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
          ),
        );
      },
    );
  }

  void applyCarpool(Carpool carpool) {
    FirebaseFirestore.instance
        .collection('carpool')
        .add(<String, dynamic>{
      'user_uid': carpool.userUid,
      'car_uid': carpool.carUid,
      'start_location': carpool.startLocation,
      'start_location_detail': carpool.startLocationDetail,
      'end_location': carpool.endLocation,
      'end_location_detail': carpool.endLocationDetail,
      'downtown': carpool.downtown,
      'max_num': carpool.maxNum,
      'current_num': 0,
      'fee': carpool.fee,
      'regular': carpool.regular,
      'departure_time': carpool.departureTime,
      'memo': carpool.memo,
      'reg_date': FieldValue.serverTimestamp(),
      'mod_date': FieldValue.serverTimestamp(),
    });
  }

  void updateCarpool(Carpool carpool) {
    FirebaseFirestore.instance
        .collection('carpool')
        .doc(carpool.id)
        .update({
      'car_uid': carpool.carUid,
      'start_location': carpool.startLocation,
      'start_location_detail': carpool.startLocationDetail,
      'end_location': carpool.endLocation,
      'end_location_detail': carpool.endLocationDetail,
      'downtown': carpool.downtown,
      'max_num': carpool.maxNum,
      'fee': carpool.fee,
      'regular': carpool.regular,
      'departure_time': carpool.departureTime,
      'memo': carpool.memo,
      'mod_date': FieldValue.serverTimestamp(),
    });
  }

  void deleteCarpool(String carpoolId) {
    FirebaseFirestore.instance
        .collection('car')
        .doc(carpoolId)
        .delete();
  }

  ListView buildCarListView(BuildContext context) {

    return ListView.builder(
      itemCount: _car.length,
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (BuildContext context, int index) {
        return Card(
          clipBehavior: Clip.antiAlias,
          child: Consumer<ApplicationState>(
            builder: (context, appState, _) => Consumer<CarpoolState>(
              builder: (context, carpoolState, _) => ListTile(
                contentPadding: const EdgeInsets.all(10.0),
                title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(_car[index].car),
                          ),
                          TextButton(
                            onPressed: () => {
                              carpoolState.deleteCar(index),
                            },
                            child: const Text("삭제",)
                          ),
                          TextButton(
                              onPressed: () => {
                                appState.setEditInformation(false, index),
                                appState.changePageIndex(8),
                              },
                              child: const Text("수정")
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(_car[index].desc),
                          ),
                        ],
                      ),
                    ]
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void addCar(String number, String desc) {
    FirebaseFirestore.instance
        .collection('car')
        .add(<String, dynamic>{
      'user_uid': FirebaseAuth.instance.currentUser!.uid,
      'car': number,
      'desc': desc,
      'reg_date': FieldValue.serverTimestamp(),
      'mod_date': FieldValue.serverTimestamp(),
    });
  }

  void updateCar(String number, String desc, int index) {
    FirebaseFirestore.instance
        .collection('car')
        .doc(_car[index].id)
        .update({
      'car': number,
      'desc': desc,
      'mod_date': FieldValue.serverTimestamp(),
    });
  }

  void deleteCar(int index) {
    FirebaseFirestore.instance
        .collection('car')
        .doc(_car[index].id)
        .delete();
  }

  bool checkParticipate(String carpoolUid) {
    for (int i = 0; i < _myCarpool.length; i++) {
      if (_myCarpool[i].carpoolUid == carpoolUid) {
        return true;
      }
    }

    return false;
  }

  void addParticipate(String carpoolUid) {
    FirebaseFirestore.instance
        .collection('participate')
        .add(<String, dynamic>{
      'user_uid': FirebaseAuth.instance.currentUser!.uid,
      'carpool_uid': carpoolUid,
      'send': false,
      'reg_date': FieldValue.serverTimestamp(),
      'mod_date': FieldValue.serverTimestamp(),
    });
  }

  void deleteParticipate(String carpoolUid) {
    int index = 0;
    print("zxcvzxcv");
    for (int i = 0; i < _myCarpool.length; i++) {
      if (_myCarpool[i].carpoolUid == carpoolUid) {
        print(_myCarpool[i].carpoolUid);
        index = i;
        break;
      }
    }

    FirebaseFirestore.instance
        .collection('participate')
        .doc(_myCarpool[index].id)
        .delete();
  }
}