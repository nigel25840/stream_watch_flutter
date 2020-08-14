import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:streamwatcher/UI/drawer.dart';
import 'package:streamwatcher/UI/state_picker.dart';
import 'package:streamwatcher/Util/Storage.dart';
import 'package:streamwatcher/Util/constants.dart';
import 'package:streamwatcher/viewModel/favorites_view_model.dart';

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

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<void> _initializePreferences() async {
    var faves = await Storage.getList(kFavoritesKey);
    if (faves == null) {
      await Storage.initializeList(kFavoritesKey);
    }
  }

  @override
  Widget build(BuildContext context) {

    _initializePreferences();

    return Scaffold(
      appBar: AppBar(
        title: Text("River Watch"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Opening page'),
          ],
        ),
      ),
      endDrawer: RFDrawer(),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
