import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:streamwatcher/UI/drawer.dart';
import 'package:streamwatcher/UI/state_picker.dart';
import 'package:streamwatcher/Util/constants.dart';
import 'package:streamwatcher/viewModel/favorites_view_model.dart';

import 'UI/home_page_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) {
    runApp(
      ChangeNotifierProvider(
        create: (context) => FavoritesViewModel(),
        child: MyApp(),
      )
    );
  });
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(), // StatePicker(title: "Pick a state"),
    );
  }
}

