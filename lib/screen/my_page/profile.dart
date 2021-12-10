import 'package:flutter/material.dart';
import 'package:mobile_app_final_project/model/carpool.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../state/carpool_state.dart';
import '../../state/firebase_state.dart';
import '../../state/application_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold
    );

    TextStyle contentStyle = const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600
    );

    ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(	//모서리를 둥글게
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.black, width: 1)
      ),
      primary: Colors.black,
      textStyle: const TextStyle(fontSize: 20, color:Colors.black),
      minimumSize: const Size(150, 40),
    );

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 40,
            child: Text("기본 정보", style: titleStyle),
          ),
          Consumer<FirebaseState>(
            builder: (context, firebaseState, _) => SizedBox(
              height: 90,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: Text("이메일", style: titleStyle)),
                      Text(FirebaseAuth.instance.currentUser!.email.toString(), style: contentStyle,),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: Text("닉네임", style: titleStyle)),
                      Text(FirebaseAuth.instance.currentUser!.displayName.toString(), style: contentStyle,),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 50,
            child: Row(
              children: [
                Expanded(child: Text("차량 정보", style: titleStyle)),
                Consumer<ApplicationState>(
                  builder: (context, appState, _) => ElevatedButton(
                    style: buttonStyle,
                    onPressed: () => {
                      appState.resetEditInformation(),
                      appState.setTabTitle("차량 등록", 8),
                      appState.changePageIndex(8),
                    },
                    child: const Text("차량 등록"),
                  ),
                ),
              ],
            )
          ),
          const Expanded(
            child: CarListView(),
          ),
          Consumer<FirebaseState>(
            builder: (context, firebaseState, _) => Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: buttonStyle,
                    onPressed: () => {
                      Navigator.pushNamed(context, '/login'),
                      firebaseState.signOut()
                    },
                    child: const Text("로그아웃"),
                  ),
                ),
              ],
            )
          ),
        ],
      ),
    );
  }
}

class CarListView extends StatefulWidget {
  const CarListView({Key? key, }) : super(key: key);

  @override
  State<CarListView> createState() => _CarListViewState();
}

class _CarListViewState extends State<CarListView> {

  TextStyle titleStyle = const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold
  );

  TextStyle contentStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600
  );

  ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(	//모서리를 둥글게
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Colors.black, width: 1)
    ),
    primary: Colors.black,
    textStyle: const TextStyle(fontSize: 16, color:Colors.black),
    minimumSize: const Size(0, 35),
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, appState, _) => Consumer<CarpoolState>(
        builder: (context, carpoolState, _) => ListView.builder(
          itemCount: carpoolState.car.length,
          padding: const EdgeInsets.all(16.0),
          itemBuilder: (BuildContext context, int index) {
            return Card(
              clipBehavior: Clip.antiAlias,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Colors.black, width: 1)
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(10.0),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(carpoolState.car[index].car, style: titleStyle,),
                        ),
                        ElevatedButton(
                          style: buttonStyle,
                          onPressed: () => {
                            carpoolState.deleteCar(index),
                          },
                          child: const Text("삭제",)
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          style: buttonStyle,
                          onPressed: () => {
                            appState.setEditInformation(false, index),
                            appState.setTabTitle("차량 수정", 8),
                            appState.changePageIndex(8),
                          },
                          child: const Text("수정")
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(carpoolState.car[index].desc, style: contentStyle),
                        ),
                      ],
                    ),
                  ]
                ),
              ),
            );
          },
        )
      )
    );
  }
}
