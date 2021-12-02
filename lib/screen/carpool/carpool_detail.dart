import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/carpool_state.dart';
import '../../state/application_state.dart';

class CarpoolDetailPage extends StatelessWidget {
  const CarpoolDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer<CarpoolState>(
        builder: (context, carpoolState, _) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: carpoolState.selectedCarpool.regular ?
                  const Text("단발성 카풀")
                  :
                  const Text("정기 카풀"),
                ),
                Text(carpoolState.selectedCarpool.currentNum.toString() + "명 / " + carpoolState.selectedCarpool.maxNum.toString() + "명"),
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
            Text(carpoolState.selectedCarpool.startLocation),
            Text(carpoolState.selectedCarpool.startLocationDetail),
            Row(
              children: [
                const Expanded(child: Text("출발지")),
                IconButton(
                  onPressed: () => print("Start location map"),
                  icon: const Icon(Icons.map_outlined),
                )
              ],
            ),
            Text(carpoolState.selectedCarpool.endLocation),
            Text(carpoolState.selectedCarpool.endLocationDetail),
            const Text("출발 시간"),
            Text(carpoolState.selectedCarpool.departureTime.toString()),
            Row(
              children: [
                const Expanded(child: Text("요금")),
                Text(carpoolState.selectedCarpool.fee.toString()),
              ],
            ),
            Row(
              children: [
                const Expanded(child: Text("운전자")),
                Text(carpoolState.selectedCarpool.userUid),
              ],
            ),
            Row(
              children: [
                const Expanded(child: Text("차량정보")),
                Text(carpoolState.selectedCarpool.carUid),
              ],
            ),
            Text(carpoolState.selectedCarpool.carUid),
            const Text("메모"),
            Text(carpoolState.selectedCarpool.memo),
            carpoolState.selectedCarpool.userUid == FirebaseAuth.instance.currentUser!.uid ?
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      onPressed: () => carpoolState.deleteCarpool(carpoolState.selectedCarpool.id),
                      child: const Text("삭제")
                  ),
                ),
                const SizedBox(width: 30,),
                Consumer<ApplicationState>(
                  builder: (context, appState, _) => Expanded(
                    child: ElevatedButton(
                      onPressed: () => {
                        appState.setEditInformation(true, 0),
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
                carpoolState.checkParticipate(carpoolState.selectedCarpool.id) ?
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => carpoolState.addParticipate(carpoolState.selectedCarpool.id),
                    child: const Text("신청")
                  ),
                )
                :
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => carpoolState.deleteParticipate(carpoolState.selectedCarpool.id),
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
