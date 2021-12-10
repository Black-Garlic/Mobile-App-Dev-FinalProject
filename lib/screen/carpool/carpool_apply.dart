import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_final_project/state/application_state.dart';
import 'package:mobile_app_final_project/state/carpool_state.dart';
import 'package:provider/provider.dart';
import '../../model/carpool.dart';
import '../../model/location.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CarpoolApplyPage extends StatelessWidget {
  const CarpoolApplyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SingleChildScrollView(child: ApplyForm(),)
    );
  }
}

class ApplyForm extends StatefulWidget {
  const ApplyForm({Key? key, }) : super(key: key);

  @override
  State<ApplyForm> createState() => _ApplyFormState();
}

class _ApplyFormState extends State<ApplyForm> {

  String _carpoolCarNum = "차량을 선택해주세요";
  String _carpoolCarDesc = "";
  String _carpoolCarUid = "nwxzVjsn6vrIFUpVwbTR";
  DateTime _selectedDate = DateTime.now();
  String _carpoolStartLocation = "학교";
  String _carpoolEndLocation = "양덕";
  final _carpoolStartLocationDetailController = TextEditingController();
  final _carpoolEndLocationDetailController = TextEditingController();
  final _carpoolNumController = TextEditingController();
  final _carpoolFeeController = TextEditingController();
  final _carpoolMemoController = TextEditingController();

  TextStyle titleStyle = const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold
  );

  TextStyle contentStyle = const TextStyle(
      fontSize: 20,
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

  double sizedBoxHeight = 15;

  Container _buildCarListView(BuildContext context, CarpoolState carpoolState) {

    return Container(
      height: 200,
      width: 200,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: carpoolState.car.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: ElevatedButton(
              style: buttonStyle,
              child: Text(carpoolState.car[index].car),
              onPressed: () => {
                setState(() {
                  _carpoolCarNum = carpoolState.car[index].car;
                  _carpoolCarDesc = carpoolState.car[index].desc;
                  _carpoolCarUid = carpoolState.car[index].id;
                }),
                Navigator.pop(context, 'Cancel')
              },
            )
          );
        },
      )
    );
  }

  Container _buildLocationListView(BuildContext context, CarpoolState carpoolState, bool start) {

    List<Location> _carpoolLocationList = carpoolState.location;

    return Container(
        height: 350,
        width: 300,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _carpoolLocationList.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: ElevatedButton(
                style: buttonStyle,
                child: Text(_carpoolLocationList[index].name),
                onPressed: () => {
                  setState(() {
                    if(start) {
                      _carpoolStartLocation = _carpoolLocationList[index].name;
                    } else {
                      _carpoolEndLocation = _carpoolLocationList[index].name;
                    }
                  }),
                  Navigator.pop(context, 'Cancel')
                },
              )
            );
          },
        )
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(1901, 1),
        lastDate: DateTime(2100)
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        print(picked);
        _selectTime(context, picked);
      });
    }
  }

  Future<Null> _selectTime(BuildContext context, DateTime selectedDate) async {
    TimeOfDay? picked = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );
    if (picked != null) {
      setState(() {
        _selectedDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, picked.hour, picked.minute);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, appState, _) => Consumer<CarpoolState>(
        builder: (context, carpoolState, _) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: appState.editPage ?
          <Widget>[
            Row(
              children: [
                Expanded(child: Text(_carpoolCarNum, style: contentStyle,)),
                ElevatedButton(
                  style: buttonStyle,
                  child: const Text("차량 선택"),
                  onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: Text("차량을 선택해주세요", style: titleStyle,),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          _buildCarListView(context, carpoolState)
                        ],
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancel'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: sizedBoxHeight),
            Row(
              children: [
                Expanded(child: Text(DateFormat("yyyy-MM-dd HH:mm").format(_selectedDate), style: contentStyle,)),
                ElevatedButton(
                  style: buttonStyle,
                  child: const Text("카풀 시간 선택"),
                  onPressed: () {
                    _selectDate(context);
                  },
                ),
              ],
            ),
            SizedBox(height: sizedBoxHeight),
            Row(
              children: [
                Expanded(child: Text("출발지", style: contentStyle,)),
              ],
            ),
            SizedBox(height: sizedBoxHeight),
            Row(
              children: [
                Expanded(child: Text(_carpoolStartLocation, style: contentStyle,)),
                ElevatedButton(
                  style: buttonStyle,
                  child: const Text("출발 지역 선택"),
                  onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: Text("출발 지역을 선택해주세요", style: titleStyle,),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          _buildLocationListView(context, carpoolState, true)
                        ],
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancel'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            TextField(
              controller: _carpoolStartLocationDetailController..text = carpoolState.selectedCarpool.startLocationDetail,
              decoration: const InputDecoration(
                  labelText: "출발 상세 주소"
              ),
              style: contentStyle,
            ),
            SizedBox(height: sizedBoxHeight),
            Row(
              children: [
                Expanded(child: Text("도착지", style: contentStyle,)),
              ],
            ),
            SizedBox(height: sizedBoxHeight),
            Row(
              children: [
                Expanded(child: Text(_carpoolEndLocation, style: contentStyle,)),
                ElevatedButton(
                  style: buttonStyle,
                  child: const Text("도착 지역 선택"),
                  onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: Text("도착 지역을 선택해주세요", style: titleStyle,),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          _buildLocationListView(context, carpoolState, false)
                        ],
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancel'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            TextField(
              controller: _carpoolEndLocationDetailController..text = carpoolState.selectedCarpool.endLocationDetail,
              decoration: const InputDecoration(
                  labelText: "도착 상세 주소"
              ),
              style: contentStyle,
            ),
            SizedBox(height: sizedBoxHeight),
            TextField(
              controller: _carpoolNumController..text = carpoolState.selectedCarpool.maxNum.toString(),
              decoration: const InputDecoration(
                  labelText: "탑승 인원"
              ),
              style: contentStyle,
            ),
            SizedBox(height: sizedBoxHeight),
            TextField(
              controller: _carpoolFeeController..text = carpoolState.selectedCarpool.fee.toString(),
              decoration: const InputDecoration(
                  labelText: "요금"
              ),
              style: contentStyle,
            ),
            SizedBox(height: sizedBoxHeight),
            TextField(
              controller: _carpoolMemoController..text = carpoolState.selectedCarpool.memo,
              decoration: const InputDecoration(
                  labelText: "메모"
              ),
              style: contentStyle,
            ),
            SizedBox(height: sizedBoxHeight),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      style: buttonStyle,
                      onPressed: () async => {
                        carpoolState.updateCarpool(
                            Carpool(
                              id: carpoolState.selectedCarpool.id,
                              userUid: carpoolState.selectedCarpool.id,
                              nickname: FirebaseAuth.instance.currentUser!.displayName.toString(),
                              carUid: _carpoolCarUid,
                              carNum: _carpoolCarNum,
                              carDesc: _carpoolCarDesc,
                              startLocation: _carpoolStartLocation,
                              startLocationDetail: _carpoolStartLocationDetailController.text,
                              endLocation: _carpoolEndLocation,
                              endLocationDetail: _carpoolEndLocationDetailController.text,
                              maxNum: int.parse(_carpoolNumController.text),
                              currentNum: carpoolState.selectedCarpool.currentNum,
                              fee: int.parse(_carpoolFeeController.text),
                              regular: false,
                              departureTime: _selectedDate,
                              memo: _carpoolMemoController.text,
                              regDate: carpoolState.selectedCarpool.regDate,
                              modDate: DateTime.now(),
                            )
                        ),
                        appState.changePageIndex(4),
                      },
                      child: const Text("수정")
                  ),
                )
              ],
            )
          ]
          :
          <Widget>[
            Row(
              children: [
                Expanded(child: Text(_carpoolCarNum, style: contentStyle,)),
                ElevatedButton(
                  style: buttonStyle,
                  child: const Text("차량 선택"),
                  onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: Text("차량을 선택해주세요", style: titleStyle,),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          _buildCarListView(context, carpoolState)
                        ],
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancel'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: sizedBoxHeight),
            Row(
              children: [
                Expanded(child: Text(DateFormat("yyyy-MM-dd HH:mm").format(_selectedDate), style: contentStyle,)),
                ElevatedButton(
                  style: buttonStyle,
                  child: const Text("카풀 시간 선택"),
                  onPressed: () {
                    _selectDate(context);
                  },
                ),
              ],
            ),
            SizedBox(height: sizedBoxHeight),
            Row(
              children: [
                Expanded(child: Text("출발지", style: contentStyle,)),
              ],
            ),
            SizedBox(height: sizedBoxHeight),
            Row(
              children: [
                Expanded(child: Text(_carpoolStartLocation, style: contentStyle,)),
                ElevatedButton(
                  style: buttonStyle,
                  child: const Text("출발 지역 선택"),
                  onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: Text("출발 지역을 선택해주세요", style: titleStyle,),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          _buildLocationListView(context, carpoolState, true)
                        ],
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancel'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            TextField(
              controller: _carpoolStartLocationDetailController,
              decoration: const InputDecoration(
                  labelText: "출발 상세 주소"
              ),
              style: contentStyle,
            ),
            SizedBox(height: sizedBoxHeight),
            Row(
              children: [
                Expanded(child: Text("도착지", style: contentStyle,)),
              ],
            ),
            SizedBox(height: sizedBoxHeight),
            Row(
              children: [
                Expanded(child: Text(_carpoolEndLocation, style: contentStyle,)),
                ElevatedButton(
                  style: buttonStyle,
                  child: const Text("도착 지역 선택"),
                  onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: Text("도착 지역을 선택해주세요", style: titleStyle,),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          _buildLocationListView(context, carpoolState, false)
                        ],
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancel'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            TextField(
              controller: _carpoolEndLocationDetailController,
              decoration: const InputDecoration(
                  labelText: "도착 상세 주소"
              ),
              style: contentStyle,
            ),
            SizedBox(height: sizedBoxHeight),
            TextField(
              controller: _carpoolNumController,
              decoration: const InputDecoration(
                  labelText: "탑승 인원"
              ),
              style: contentStyle,
            ),
            SizedBox(height: sizedBoxHeight),
            TextField(
              controller: _carpoolFeeController,
              decoration: const InputDecoration(
                  labelText: "요금"
              ),
              style: contentStyle,
            ),
            SizedBox(height: sizedBoxHeight),
            TextField(
              controller: _carpoolMemoController,
              decoration: const InputDecoration(
                  labelText: "메모"
              ),
              style: contentStyle,
            ),
            SizedBox(height: sizedBoxHeight),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      style: buttonStyle,
                      onPressed: () async => {
                        carpoolState.applyCarpool(
                            Carpool(
                              id: "",
                              userUid: FirebaseAuth.instance.currentUser!.uid,
                              nickname: FirebaseAuth.instance.currentUser!.displayName.toString(),
                              carUid: _carpoolCarUid,
                              carNum: _carpoolCarNum,
                              carDesc: _carpoolCarDesc,
                              startLocation: _carpoolStartLocation,
                              startLocationDetail: _carpoolStartLocationDetailController.text,
                              endLocation: _carpoolEndLocation,
                              endLocationDetail: _carpoolEndLocationDetailController.text,
                              maxNum: int.parse(_carpoolNumController.text),
                              currentNum: 0,
                              fee: int.parse(_carpoolFeeController.text),
                              regular: false,
                              departureTime: _selectedDate,
                              memo: _carpoolMemoController.text,
                              regDate: DateTime.now(),
                              modDate: DateTime.now(),
                            )
                        ),
                        appState.changePageIndex(4),
                      },
                      child: const Text("등록")
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
