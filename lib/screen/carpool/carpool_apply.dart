import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_final_project/state/application_state.dart';
import 'package:mobile_app_final_project/state/carpool_state.dart';
import 'package:provider/provider.dart';
import '../../model/carpool.dart';
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
  String _carpoolCarUid = "nwxzVjsn6vrIFUpVwbTR";
  DateTime _selectedDate = DateTime.now();
  final _carpoolStartLocationController = TextEditingController();
  final _carpoolStartLocationDetailController = TextEditingController();
  final _carpoolEndLocationController = TextEditingController();
  final _carpoolEndLocationDetailController = TextEditingController();
  final _carpoolNumController = TextEditingController();
  final _carpoolFeeController = TextEditingController();
  final _carpoolMemoController = TextEditingController();

  bool _downtown = true;

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
              child: Text(carpoolState.car[index].car),
              onPressed: () => {
                setState(() {
                  _carpoolCarNum = carpoolState.car[index].car;
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
                Expanded(child: Text(_carpoolCarNum)),
                ElevatedButton(
                  child: const Text("차량 선택"),
                  onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text("차량을 선택해주세요"),
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
            Row(
              children: [
                Expanded(child: Text(_selectedDate.toString())),
                ElevatedButton(
                  child: const Text("날짜 선택"),
                  onPressed: () {
                    _selectDate(context);
                  },
                ),
              ],
            ),
            Row(
              children: [
                const Expanded(child: Text("출발지")),
                IconButton(
                  onPressed: () => print("Start location map"),
                  icon: const Icon(Icons.map_outlined),
                )
              ],
            ),
            TextField(
              controller: _carpoolStartLocationController..text = carpoolState.selectedCarpool.startLocation,
              decoration: const InputDecoration(
                labelText: "출발 주소"
              ),
            ),
            TextField(
              controller: _carpoolStartLocationDetailController..text = carpoolState.selectedCarpool.startLocationDetail,
              decoration: const InputDecoration(
                  labelText: "출발 상세 주소"
              ),
            ),
            Row(
              children: [
                const Expanded(child: Text("도착지")),
                IconButton(
                  onPressed: () => print("End location map"),
                  icon: const Icon(Icons.map_outlined),
                )
              ],
            ),
            TextField(
              controller: _carpoolEndLocationController..text = carpoolState.selectedCarpool.endLocation,
              decoration: const InputDecoration(
                  labelText: "도착 주소"
              ),
            ),
            TextField(
              controller: _carpoolEndLocationDetailController..text = carpoolState.selectedCarpool.endLocationDetail,
              decoration: const InputDecoration(
                  labelText: "도착 상세 주소"
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    child: Text(
                        "시내",
                      style: _downtown ?
                      const TextStyle(
                        fontWeight: FontWeight.bold,
                      )
                        :
                      const TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onPressed: () => {
                      setState(() {
                        if (!_downtown) {
                          _downtown = true;
                        }
                      })
                    },
                  ),
                ),
                Expanded(
                  child: TextButton(
                    child: Text(
                      "시외",
                      style: !_downtown ?
                      const TextStyle(
                        fontWeight: FontWeight.bold,
                      )
                          :
                      const TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onPressed: () => {
                      setState(() {
                        if (_downtown) {
                          _downtown = false;
                        }
                      })
                    },
                  ),
                ),
              ],
            ),
            TextField(
              controller: _carpoolNumController..text = carpoolState.selectedCarpool.maxNum.toString(),
              decoration: const InputDecoration(
                  labelText: "탑승 인원"
              ),
            ),
            TextField(
              controller: _carpoolFeeController..text = carpoolState.selectedCarpool.fee.toString(),
              decoration: const InputDecoration(
                  labelText: "요금"
              ),
            ),
            TextField(
              controller: _carpoolMemoController..text = carpoolState.selectedCarpool.memo,
              decoration: const InputDecoration(
                  labelText: "메모"
              ),
            ),
            TextButton(
              onPressed: () async => {
                carpoolState.updateCarpool(
                  Carpool(
                    id: carpoolState.selectedCarpool.id,
                    userUid: carpoolState.selectedCarpool.id,
                    carUid: _carpoolCarUid,
                    startLocation: _carpoolStartLocationController.text,
                    startLocationDetail: _carpoolStartLocationDetailController.text,
                    endLocation: _carpoolEndLocationController.text,
                    endLocationDetail: _carpoolEndLocationDetailController.text,
                    downtown: _downtown,
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
              },
              child: const Text("수정")
            ),
          ]
          :
          <Widget>[
            Row(
              children: [
                Expanded(child: Text(_carpoolCarNum)),
                ElevatedButton(
                  child: const Text("차량 선택"),
                  onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text("차량을 선택해주세요"),
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
            Row(
              children: [
                Expanded(child: Text(_selectedDate.toString())),
                ElevatedButton(
                  child: const Text("날짜 선택"),
                  onPressed: () {
                    _selectDate(context);
                  },
                ),
              ],
            ),
            Row(
              children: [
                const Expanded(child: Text("출발지")),
                IconButton(
                  onPressed: () => print("Start location map"),
                  icon: const Icon(Icons.map_outlined),
                )
              ],
            ),
            TextField(
              controller: _carpoolStartLocationController,
              decoration: const InputDecoration(
                  labelText: "출발 주소"
              ),
            ),
            TextField(
              controller: _carpoolStartLocationDetailController,
              decoration: const InputDecoration(
                  labelText: "출발 상세 주소"
              ),
            ),
            Row(
              children: [
                const Expanded(child: Text("도착지")),
                IconButton(
                  onPressed: () => print("End location map"),
                  icon: const Icon(Icons.map_outlined),
                )
              ],
            ),
            TextField(
              controller: _carpoolEndLocationController,
              decoration: const InputDecoration(
                  labelText: "도착 주소"
              ),
            ),
            TextField(
              controller: _carpoolEndLocationDetailController,
              decoration: const InputDecoration(
                  labelText: "도착 상세 주소"
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    child: Text(
                      "시내",
                      style: _downtown ?
                      const TextStyle(
                        fontWeight: FontWeight.bold,
                      )
                          :
                      const TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onPressed: () => {
                      setState(() {
                        if (!_downtown) {
                          _downtown = true;
                        }
                      })
                    },
                  ),
                ),
                Expanded(
                  child: TextButton(
                    child: Text(
                      "시외",
                      style: !_downtown ?
                      const TextStyle(
                        fontWeight: FontWeight.bold,
                      )
                          :
                      const TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onPressed: () => {
                      setState(() {
                        if (_downtown) {
                          _downtown = false;
                        }
                      })
                    },
                  ),
                ),
              ],
            ),
            TextField(
              controller: _carpoolNumController,
              decoration: const InputDecoration(
                  labelText: "탑승 인원"
              ),
            ),
            TextField(
              controller: _carpoolFeeController,
              decoration: const InputDecoration(
                  labelText: "요금"
              ),
            ),
            TextField(
              controller: _carpoolMemoController,
              decoration: const InputDecoration(
                  labelText: "메모"
              ),
            ),
            TextButton(
              onPressed: () async => {
                carpoolState.applyCarpool(
                  Carpool(
                    id: "",
                    userUid: FirebaseAuth.instance.currentUser!.uid,
                    carUid: _carpoolCarUid,
                    startLocation: _carpoolStartLocationController.text,
                    startLocationDetail: _carpoolStartLocationDetailController.text,
                    endLocation: _carpoolEndLocationController.text,
                    endLocationDetail: _carpoolEndLocationDetailController.text,
                    downtown: _downtown,
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
              },
              child: const Text("등록")
            ),
          ],
        ),
      ),
    );
  }
}
