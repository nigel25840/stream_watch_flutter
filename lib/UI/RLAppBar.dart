

import 'package:flutter/material.dart';

class RLAppBar extends StatelessWidget with PreferredSizeWidget {

  final String title;
  final Size preferredSize;
  final double height;

  RLAppBar(this.title, this.height, {Key key})
      : preferredSize = Size.fromHeight(height),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: true,
      leading: IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.white), onPressed:() {
        Navigator.pop(context, false);
      },),
      title: Text(title),
    );
  }
}
