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
            ),
            TextField(
              controller: _carpoolCarDescController..text = carpoolState.car[appState.editCarIndex].desc,
              decoration: const InputDecoration(
                  labelText: "차량 설명"
              ),
            ),
            TextButton(
                onPressed: () async => {
                  carpoolState.updateCar(_carpoolCarNumController.text, _carpoolCarDescController.text, appState.editCarIndex),
                },
                child: Text("수정")
            ),
          ]
              :
          <Widget>[
            TextField(
              controller: _carpoolCarNumController,
              decoration: const InputDecoration(
                  labelText: "차량 번호"
              ),
            ),
            TextField(
              controller: _carpoolCarDescController,
              decoration: const InputDecoration(
                  labelText: "차량 설명"
              ),
            ),
            TextButton(
                onPressed: () async => {
                  carpoolState.addCar(_carpoolCarNumController.text, _carpoolCarDescController.text),
                },
                child: Text("등록")
            ),
          ],
        ),
      ),
    );
  }
}
