import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_final_project/model/carpool.dart';
import 'package:mobile_app_final_project/model/participate.dart';
import 'package:mobile_app_final_project/model/chat.dart';
import 'package:mobile_app_final_project/state/application_state.dart';
import 'package:mobile_app_final_project/state/carpool_state.dart';
import 'package:provider/provider.dart';

class ChatRoomPage extends StatelessWidget {
  const ChatRoomPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: ChatWidget(),
    );
  }
}

class ChatWidget extends StatefulWidget {
  const ChatWidget({Key? key,}) : super(key: key);

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {

  final _chatController = TextEditingController();

  TextStyle titleStyle = const TextStyle(
      fontSize: 18,
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

  ListView buildChatListView(BuildContext context, CarpoolState carpoolState, ApplicationState appState) {
    String chatRoom = carpoolState.selectedChatRoom;
    String userUid = FirebaseAuth.instance.currentUser!.uid;

    List<Chat> chatList = [];

    for (Chat chat in carpoolState.chat) {
      if (chat.carpoolUid == chatRoom) {
        chatList.add(chat);
      }
    }

    return ListView.builder(
      itemCount: chatList.length,
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: chatList[index].userUid == userUid ? const EdgeInsets.fromLTRB(90.0, 0, 0, 0) : const EdgeInsets.fromLTRB(0, 0, 90.0, 0),
          child: Card(
            clipBehavior: Clip.antiAlias,
            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Colors.black, width: 1)
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(10.0),
              title: Row(
                children:[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: chatList[index].userUid == userUid ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Text(chatList[index].nickname, style: titleStyle),
                        const SizedBox(height: 10,),
                        Text(chatList[index].message, style: contentStyle),
                        const SizedBox(height: 10,),
                        Text(chatList[index].regDate.toString(), style: contentStyle),
                      ],
                    )
                  ),
                ]
              ),
            ),
          )
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, appState, _) => Consumer<CarpoolState>(
        builder: (context, carpoolState, _) => Column(
          children: [
            Expanded(
              child: buildChatListView(context, carpoolState, appState),
            ),
            SizedBox(
              height: 50,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _chatController,
                      decoration: const InputDecoration(
                          labelText: "메시지 작성"
                      ),
                      style: contentStyle
                    ),
                  ),
                  ElevatedButton(
                    style: buttonStyle,
                    onPressed: () => {
                      if (_chatController.text.isNotEmpty) {
                        carpoolState.sendChat(
                          Chat(
                            id: '',
                            userUid: FirebaseAuth.instance.currentUser!.uid,
                            nickname: FirebaseAuth.instance.currentUser!.displayName.toString(),
                            carpoolUid: carpoolState.selectedChatRoom,
                            message: _chatController.text,
                            regDate: DateTime.now(),
                            modDate: DateTime.now(),
                          )
                        ),
                        _chatController.text = "",
                      }
                    },
                    child: const Text("전송")
                  )
                ],
              ),
            )
          ]
        )
      ),
    );
  }
}
