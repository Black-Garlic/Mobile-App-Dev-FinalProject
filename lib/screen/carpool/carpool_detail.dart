import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../state/carpool_state.dart';
import '../../state/application_state.dart';

class CarpoolDetailPage extends StatelessWidget {
  const CarpoolDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold
    );

    TextStyle contentStyle = const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w400
    );

    ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(	//모서리를 둥글게
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Colors.black, width: 1)
      ),
      primary: Colors.black,
      textStyle: const TextStyle(fontSize: 20, color:Colors.black)
    );

    double sizedBoxHeight = 25;

    return Consumer<ApplicationState>(
      builder: (context, appState, _) => Consumer<CarpoolState>(
        builder: (context, carpoolState, _) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(carpoolState.selectedCarpool.startLocation, style: titleStyle,),
                      Text(carpoolState.selectedCarpool.startLocationDetail, style: titleStyle,),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_rounded),
                Expanded(
                  child: Column(
                    children: [
                      Text(carpoolState.selectedCarpool.endLocation, style: titleStyle,),
                      Text(carpoolState.selectedCarpool.endLocationDetail, style: titleStyle,),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: sizedBoxHeight),
            Row(
              children: [
                Expanded(child: Text("탑승 인원", style: titleStyle)),
                Text(carpoolState.selectedCarpool.currentNum.toString() + "명 / " + carpoolState.selectedCarpool.maxNum.toString() + "명", style: contentStyle,),
              ],
            ),
            SizedBox(height: sizedBoxHeight),
            Row(
              children: [
                Expanded(child: Text("출발 시간", style: titleStyle)),
                Text(DateFormat("yyyy-MM-dd HH:mm").format(carpoolState.selectedCarpool.departureTime), style: contentStyle,),
              ],
            ),
            SizedBox(height: sizedBoxHeight),
            Row(
              children: [
                Expanded(child: Text("요금", style: titleStyle)),
                Text(carpoolState.selectedCarpool.fee.toString() + "원", style: contentStyle,),
              ],
            ),
            SizedBox(height: sizedBoxHeight),
            Row(
              children: [
                Expanded(child: Text("운전자", style: titleStyle)),
                Text(carpoolState.selectedCarpool.nickname, style: contentStyle,),
              ],
            ),
            SizedBox(height: sizedBoxHeight),
            Row(
              children: [
                Expanded(child: Text("차량 번호", style: titleStyle)),
                Text(carpoolState.selectedCarpool.carNum, style: contentStyle,),
              ],
            ),
            SizedBox(height: sizedBoxHeight),
            Row(
              children: [
                Expanded(child: Text("차량 정보", style: titleStyle)),
                Text(carpoolState.selectedCarpool.carDesc, style: contentStyle,),
              ],
            ),
            SizedBox(height: sizedBoxHeight),
            Row(
              children: [
                Expanded(child: Text("메모", style: titleStyle)),
                Text(carpoolState.selectedCarpool.memo, style: contentStyle,),
              ],
            ),
            SizedBox(height: sizedBoxHeight),
            carpoolState.selectedCarpool.userUid == FirebaseAuth.instance.currentUser!.uid ?
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: buttonStyle,
                    onPressed: () => {
                      carpoolState.deleteCarpool(carpoolState.selectedCarpool.id),
                      appState.changePageIndex(4),
                    },
                    child: const Text("삭제")
                  ),
                ),
                const SizedBox(width: 20,),
                Consumer<ApplicationState>(
                  builder: (context, appState, _) => Expanded(
                    child: ElevatedButton(
                      style: buttonStyle,
                      onPressed: () => {
                        appState.setEditInformation(true, 0),
                        appState.setTabTitle("카풀 수정", 5),
                        appState.changePageIndex(5),
                      },
                      child: const Text("수정")
                    ),
                  ),
                ),
              ],
            )
                :
            Row(
              children: [
                !carpoolState.checkParticipate(carpoolState.selectedCarpool.id) ?
                Expanded(
                  child: ElevatedButton(
                    style: buttonStyle,
                    onPressed: () => {
                      carpoolState.addParticipate(carpoolState.selectedCarpool.id, carpoolState.selectedCarpool.currentNum),
                      appState.changePageIndex(4),
                    },
                    child: const Text("참여"),
                  ),
                )
                    :
                Expanded(
                  child: ElevatedButton(
                    style: buttonStyle,
                    onPressed: () => {
                      carpoolState.deleteParticipate(carpoolState.selectedCarpool.id, carpoolState.selectedCarpool.currentNum),
                      appState.changePageIndex(4),
                    },
                    child: const Text("취소")
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}