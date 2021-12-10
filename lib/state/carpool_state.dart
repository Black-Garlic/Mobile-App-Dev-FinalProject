import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_final_project/state/application_state.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/carpool.dart';
import '../model/location.dart';
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

  StreamSubscription<QuerySnapshot>? _chatSubscription;
  List<Chat> _chat = [];
  List<Chat> get chat => _chat;

  StreamSubscription<QuerySnapshot>? _carSubscription;
  List<Car> _car = [];
  List<Car> get car => _car;

  StreamSubscription<QuerySnapshot>? _locationSubscription;
  List<Location> _location = [];
  List<Location> get location => _location;

  late Carpool _selectedCarpool;
  Carpool get selectedCarpool => _selectedCarpool;

  late String _selectedChatRoom;
  String get selectedChatRoom => _selectedChatRoom;

  CarpoolState() {
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp();

    FirebaseAuth.instance.userChanges().listen((user) {
      print("change user");
      if (user != null) {
        initStream(user);
      }
      notifyListeners();
    });
  }

  void initStream(User user) {
    print("this is uid");
    print(user.uid);
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
            nickname: document.data()['nickname'] as String,
            carUid: document.data()['car_uid'] as String,
            carNum: document.data()['car_num'] as String,
            carDesc: document.data()['car_desc'] as String,
            startLocation: document.data()['start_location'] as String,
            startLocationDetail: document.data()['start_location_detail'] as String,
            endLocation: document.data()['end_location'] as String,
            endLocationDetail: document.data()['end_location_detail'] as String,
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
        notifyListeners();
        _selectedCarpool = _carpool[0];
      }
    });
    _myCarpoolSubscription = FirebaseFirestore.instance
        .collection('participate')
        .orderBy('reg_date', descending: true)
        .snapshots()
        .listen((snapshot) {
      _myCarpool = [];
      for (final document in snapshot.docs) {
        print("My carpool");
        print(document.data()['user_uid']);
        if (document.data()['user_uid'] == FirebaseAuth.instance.currentUser!.uid) {
          _myCarpool.add(
            Parcitipate(
              id: document.id,
              userUid: document.data()['user_uid'] as String,
              nickname: document.data()['nickname'] as String,
              carpoolUid: document.data()['carpool_uid'] as String,
              send: document.data()['send'] as bool,
              regDate: document.data()['reg_date'].toDate() as DateTime,
              modDate: document.data()['mod_date'].toDate() as DateTime,
            ),
          );
          notifyListeners();
        }
      }
    });
    _chatSubscription = FirebaseFirestore.instance
        .collection('chat')
        .orderBy('reg_date')
        .snapshots()
        .listen((snapshot) {
      _chat = [];
      for (final document in snapshot.docs) {
        _chat.add(
          Chat(
            id: document.id,
            userUid: document.data()['user_uid'] as String,
            nickname: document.data()['nickname'] as String,
            carpoolUid: document.data()['carpool_uid'] as String,
            message: document.data()['message'] as String,
            regDate: document.data()['reg_date'].toDate() as DateTime,
            modDate: document.data()['mod_date'].toDate() as DateTime,
          ),
        );
        notifyListeners();
      }
    });
    _carSubscription = FirebaseFirestore.instance
        .collection('car')
        .orderBy('reg_date', descending: true)
        .snapshots()
        .listen((snapshot) {
      _car = [];
      for (final document in snapshot.docs) {
        if (document.data()['user_uid'] == FirebaseAuth.instance.currentUser!.uid) {
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
          notifyListeners();
        }
      }
    });

    _locationSubscription = FirebaseFirestore.instance
        .collection('location')
        .orderBy('reg_date')
        .snapshots()
        .listen((snapshot) {
      _location = [];
      for (final document in snapshot.docs) {
        _location.add(
          Location(
            id: document.id,
            name: document.data()['name'] as String,
            regDate: document.data()['reg_date'].toDate() as DateTime,
            modDate: document.data()['mod_date'].toDate() as DateTime,
          ),
        );
        notifyListeners();
      }
    });
  }

  void setSelectedCarpool(Carpool carpool) {
    _selectedCarpool = carpool;
  }

  void setSelectedChatRoom(String uid) {
    _selectedChatRoom = uid;
  }

  void applyCarpool(Carpool carpool) {
    FirebaseFirestore.instance
        .collection('carpool')
        .add(<String, dynamic>{
      'user_uid': carpool.userUid,
      'nickname': carpool.nickname,
      'car_uid': carpool.carUid,
      'car_num': carpool.carNum,
      'car_desc': carpool.carDesc,
      'start_location': carpool.startLocation,
      'start_location_detail': carpool.startLocationDetail,
      'end_location': carpool.endLocation,
      'end_location_detail': carpool.endLocationDetail,
      'max_num': carpool.maxNum,
      'current_num': 0,
      'fee': carpool.fee,
      'regular': carpool.regular,
      'departure_time': carpool.departureTime,
      'memo': carpool.memo,
      'reg_date': FieldValue.serverTimestamp(),
      'mod_date': FieldValue.serverTimestamp(),
    });

    notifyListeners();
  }

  void updateCarpool(Carpool carpool) {
    FirebaseFirestore.instance
        .collection('carpool')
        .doc(carpool.id)
        .update({
      'car_uid': carpool.carUid,
      'car_num': carpool.carNum,
      'car_desc': carpool.carDesc,
      'start_location': carpool.startLocation,
      'start_location_detail': carpool.startLocationDetail,
      'end_location': carpool.endLocation,
      'end_location_detail': carpool.endLocationDetail,
      'max_num': carpool.maxNum,
      'fee': carpool.fee,
      'regular': carpool.regular,
      'departure_time': carpool.departureTime,
      'memo': carpool.memo,
      'mod_date': FieldValue.serverTimestamp(),
    });

    notifyListeners();
  }

  void deleteCarpool(String carpoolId) {
    FirebaseFirestore.instance
        .collection('carpool')
        .doc(carpoolId)
        .delete();

    notifyListeners();
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

    notifyListeners();
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

    notifyListeners();
  }

  void deleteCar(int index) {
    FirebaseFirestore.instance
        .collection('car')
        .doc(_car[index].id)
        .delete();

    notifyListeners();
  }

  bool checkParticipate(String carpoolUid) {
    for (int i = 0; i < _myCarpool.length; i++) {
      if (_myCarpool[i].carpoolUid == carpoolUid) {
        return true;
      }
    }

    return false;
  }

  void addParticipate(String carpoolUid, int currentNum) {
    FirebaseFirestore.instance
        .collection('participate')
        .add(<String, dynamic>{
      'user_uid': FirebaseAuth.instance.currentUser!.uid,
      'nickname': FirebaseAuth.instance.currentUser!.displayName,
      'carpool_uid': carpoolUid,
      'send': false,
      'reg_date': FieldValue.serverTimestamp(),
      'mod_date': FieldValue.serverTimestamp(),
    });

    FirebaseFirestore.instance
        .collection('carpool')
        .doc(carpoolUid)
        .update({
      'current_num': currentNum + 1,
      'mod_date': FieldValue.serverTimestamp(),
    });

    sendChat(
        Chat(
          id: '',
          userUid: FirebaseAuth.instance.currentUser!.uid,
          nickname: FirebaseAuth.instance.currentUser!.displayName.toString(),
          carpoolUid: carpoolUid,
          message: FirebaseAuth.instance.currentUser!.displayName.toString() + "님께서 카풀에 참여하셨습니다",
          regDate: DateTime.now(),
          modDate: DateTime.now(),
        )
    );
    
    notifyListeners();
  }

  void deleteParticipate(String carpoolUid, int currentNum) {
    int index = 0;
    for (int i = 0; i < _myCarpool.length; i++) {
      if (_myCarpool[i].carpoolUid == carpoolUid) {
        index = i;
        break;
      }
    }

    FirebaseFirestore.instance
        .collection('participate')
        .doc(_myCarpool[index].id)
        .delete();

    FirebaseFirestore.instance
        .collection('carpool')
        .doc(carpoolUid)
        .update({
      'current_num': currentNum - 1,
      'mod_date': FieldValue.serverTimestamp(),
    });
    
    sendChat(
      Chat(
        id: '',
        userUid: FirebaseAuth.instance.currentUser!.uid,
        nickname: FirebaseAuth.instance.currentUser!.displayName.toString(),
        carpoolUid: carpoolUid,
        message: FirebaseAuth.instance.currentUser!.displayName.toString() + "님께서 카풀 참여를 취소하셨습니다",
        regDate: DateTime.now(),
        modDate: DateTime.now(),
      )
    );

    notifyListeners();
  }

  void sendChat(Chat chat) {
    FirebaseFirestore.instance
        .collection('chat')
        .add(<String, dynamic>{
      'user_uid': chat.userUid,
      'nickname': chat.nickname,
      'carpool_uid': chat.carpoolUid,
      'message': chat.message,
      'reg_date': FieldValue.serverTimestamp(),
      'mod_date': FieldValue.serverTimestamp(),
    });
    notifyListeners();
  }
}