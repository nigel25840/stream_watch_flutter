
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'drawer.dart';

class DisclaimerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextStyle headerStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 18);
    TextStyle bodyStyle = TextStyle(fontSize: 15);
    return Scaffold(
      appBar: AppBar(
        title: Text("Disclaimer"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('River Watch', style: headerStyle),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('The real-time data provided by River Link is gathered from the United States Geologic Survey (USGS).', style: bodyStyle),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('The data is provisional and is subject to change. Provisional data may be inaccurate due to instrument malfunctions, internet connectivity issues, or physical changes beyond the control of this application and its developers.', style: bodyStyle),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Users of this app are cautioned to carefully consider the provisional nature of this information before making decisions based on this data, especially when there may be personal or public safety considerations.', style: bodyStyle),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Information concerning accuracy of automated river data may be obtained from the USGS.', style: bodyStyle),
            ),
          ],
        ),
      ),
      endDrawer: RFDrawer(),
    );
  }

}