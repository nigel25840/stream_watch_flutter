import 'package:flutter/material.dart';
import 'package:streamwatcher/chart/gauge_detail.dart';
import 'package:streamwatcher/gauge_selector.dart';
import 'package:streamwatcher/state_gauges_view.dart';
import 'package:streamwatcher/state_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'River Watch',)
      );
  }
}

// home: StatePicker(title: "Pick a state"),

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _currentIndex = 0;

  final List<Widget> views = [
    Text('Home'),
    Text('Favorites'),
    StateGaugesView(),
  ];

  void onNavbarItemTapped(int index){
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("River Watch") // Text(widget.title),
      ),
      body: views[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onNavbarItemTapped,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), title: Text('Home')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.star), title: Text('Favorites')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.search), title: Text('Search')
          )
        ],
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
