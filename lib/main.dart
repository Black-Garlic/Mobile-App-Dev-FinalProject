import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'state/application_state.dart';
import 'state/firebase_state.dart';
import 'state/carpool_state.dart';

void main() {
  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider<ApplicationState>(create: (context) => ApplicationState()),
            ChangeNotifierProvider<FirebaseState>(create: (context) => FirebaseState(context)),
            ChangeNotifierProvider<CarpoolState>(create: (context) => CarpoolState()),
          ],
          child: const CarpoolApp()
      )
  );
}
