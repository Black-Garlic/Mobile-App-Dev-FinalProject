import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_final_project/model/carpool.dart';
import 'package:mobile_app_final_project/model/participate.dart';
import 'package:mobile_app_final_project/state/application_state.dart';
import 'package:mobile_app_final_project/state/carpool_state.dart';
import 'package:provider/provider.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CarListView()
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

  ListView buildChatListView(BuildContext context, ApplicationState appState, CarpoolState carpoolState) {
    List<Carpool> carpoolList = [];

    for (Carpool carpool in carpoolState.carpool) {
      for (Parcitipate participate in carpoolState.myCarpool) {
        if (participate.carpoolUid == carpool.id) {
          carpoolList.add(carpool);
          break;
        }
      }
      if (carpool.userUid == FirebaseAuth.instance.currentUser!.uid) {
        carpoolList.add(carpool);
      }
    }

    return ListView.builder(
      itemCount: carpoolList.length,
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (BuildContext context, int index) {
        String chatRoomTitle = carpoolList[index].startLocation + "(" + carpoolList[index].startLocationDetail + ") -> "
            + carpoolList[index].endLocation + "(" + carpoolList[index].endLocationDetail + ")";

        return Card(
          clipBehavior: Clip.antiAlias,
          elevation: 3,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Colors.black, width: 1)
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(10.0),
            onTap: () => {
              carpoolState.setSelectedChatRoom(carpoolList[index].id),
              appState.setTabTitle(chatRoomTitle, 3),
              appState.changePageIndex(3),
            },
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(carpoolList[index].startLocation, style: titleStyle),
                          const SizedBox(height: 10),
                          Text(carpoolList[index].startLocationDetail, style: contentStyle),
                        ],
                      )
                    ),
                    const Icon(Icons.arrow_forward_rounded),
                    Expanded(
                      child: Column(
                        children: [
                          Text(carpoolList[index].endLocation, style: titleStyle),
                          const SizedBox(height: 10),
                          Text(carpoolList[index].endLocationDetail, style: contentStyle),
                        ],
                      )
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(DateFormat("yyyy-MM-dd HH:mm").format(carpoolState.carpool[index].departureTime), style: contentStyle,),
                    ),
                    carpoolList[index].userUid == FirebaseAuth.instance.currentUser!.uid ? Text("운전자", style: contentStyle) : Text("카풀 참여", style: contentStyle)
                  ],
                )
                
              ]
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<ApplicationState>(
      builder: (context, appState, _) => Consumer<CarpoolState>(
          builder: (context, carpoolState, _) => buildChatListView(context, appState, carpoolState),
      )
    );
  }
}