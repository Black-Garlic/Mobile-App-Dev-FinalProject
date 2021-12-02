import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../state/carpool_state.dart';
import '../../state/firebase_state.dart';
import '../../state/application_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(
            height: 50,
            child: Text("기본 정보"),
          ),
          Consumer<FirebaseState>(
            builder: (context, firebaseState, _) => SizedBox(
              height: 50,
              child: Column(
                children: [
                  Row(
                    children: [
                      const Expanded(child: Text("이름")),
                      Text(FirebaseAuth.instance.currentUser!.displayName.toString()),
                    ],
                  ),
                  Row(
                    children: [
                      const Expanded(child: Text("닉네임")),
                      Text(FirebaseAuth.instance.currentUser!.displayName.toString()),
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
                const Expanded(child: Text("차량 정보")),
                Consumer<ApplicationState>(
                  builder: (context, appState, _) => TextButton(
                    onPressed: () => {
                      appState.resetEditInformation(),
                      appState.changePageIndex(8),
                    },
                    child: const Text("차량 등록"),
                  ),
                ),
              ],
            )
          ),
          Expanded(
            child: Consumer<CarpoolState>(
                builder: (context, carpoolState, _) => carpoolState.buildCarListView(context)
            ),
          ),
          Consumer<FirebaseState>(
            builder: (context, firebaseState, _) => TextButton(
              onPressed: () => firebaseState.signOut(),
              child: const Text("로그아웃"),
            ),
          ),
        ],
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
