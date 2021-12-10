import 'package:flutter/material.dart';
import 'package:mobile_app_final_project/state/application_state.dart';
import 'package:mobile_app_final_project/state/carpool_state.dart';
import 'package:provider/provider.dart';

class CarAddPage extends StatelessWidget {
  const CarAddPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Form(),
    );
  }
}

class Form extends StatefulWidget {
  const Form({Key? key,}) : super(key: key);

  @override
  State<Form> createState() => _FormState();
}

class _FormState extends State<Form> {
  final _carpoolCarNumController = TextEditingController();
  final _carpoolCarDescController = TextEditingController();

  TextStyle titleStyle = const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold
  );

  ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(	//모서리를 둥글게
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Colors.black, width: 1)
    ),
    primary: Colors.black,
    textStyle: const TextStyle(fontSize: 20, color:Colors.black),
    minimumSize: const Size(0, 40),
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, appState, _) => Consumer<CarpoolState>(
        builder: (context, carpoolState, _) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: appState.editPage ?
          <Widget>[
            TextField(
              controller: _carpoolCarNumController..text = carpoolState.car[appState.editCarIndex].car,
              decoration: const InputDecoration(
                labelText: "차량 번호"
              ),
              style: titleStyle,
            ),
            const SizedBox(height: 50),
            TextField(
              controller: _carpoolCarDescController..text = carpoolState.car[appState.editCarIndex].desc,
              decoration: const InputDecoration(
                labelText: "차량 설명",
              ),
              style: titleStyle,
            ),
            const SizedBox(height: 50),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: buttonStyle,
                    onPressed: () async => {
                      carpoolState.updateCar(_carpoolCarNumController.text, _carpoolCarDescController.text, appState.editCarIndex),
                      appState.changePageIndex(7),
                    },
                    child: const Text("수정")
                  ),
                )
              ],
            )
          ]
          :
          <Widget>[
            TextField(
              controller: _carpoolCarNumController,
              decoration: const InputDecoration(
                labelText: "차량 번호"
              ),
              style: titleStyle,
            ),
            const SizedBox(height: 50),
            TextField(
              controller: _carpoolCarDescController,
              decoration: const InputDecoration(
                labelText: "차량 설명"
              ),
              style: titleStyle,
            ),
            const SizedBox(height: 50),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: buttonStyle,
                    onPressed: () async => {
                      carpoolState.addCar(_carpoolCarNumController.text, _carpoolCarDescController.text),
                      appState.changePageIndex(7),
                    },
                    child: const Text("등록")
                  ),
                )
              ]
            )
          ],
        ),
      ),
    );
  }
}
