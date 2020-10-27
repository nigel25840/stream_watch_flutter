import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:streamwatcher/viewModel/favorites_view_model.dart';
import 'package:streamwatcher/viewModel/gauge_detail_viewmodel.dart';

import 'UI/home_page_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(
      MultiProvider(providers: [
        ChangeNotifierProvider(create: (context) => FavoritesViewModel()),
        ChangeNotifierProvider(create: (context) => GaugeDetailViewModel())
      ],
      child: MyApp(),)
    );
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(), // StatePicker(title: "Pick a state"),
    );
  }
}

