import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streamwatcher/UI/rl_appbar.dart';
import 'package:streamwatcher/UI/drawer.dart';

class HelpView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextStyle sectionHeaderStyle =
        TextStyle(fontSize: 20, fontWeight: FontWeight.w500);
    TextStyle itemStyle = TextStyle(fontSize: 16);
    return Scaffold(
      appBar: RLAppBar(titleText: Text('Help Me!')),
      endDrawer: RFDrawer(),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Adding and managing favorites',
                  style: sectionHeaderStyle,
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 8, bottom: 8, right: 10),
                child: Text(
                    'Favorites can be added or removed from the search results page by tapping the star icon to the left of each search result',
                    textAlign: TextAlign.left,
                    style: itemStyle),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: Image(
                    image: AssetImage("images/searchFavorites.png"),
                  ),
                ),
              ),
              Divider(color: Colors.blue,),
              Row(
                children: [
                  Flexible(
                    flex: 7,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, top: 8, bottom: 8, right: 10),
                      child: Column(
                        children: [
                          Text(
                              'You may also use the gauge detail view by tapping on the expandable button at the lower right corner of the screen, '
                                  'then by tapping the star button at the top.',
                              textAlign: TextAlign.left,
                              style: itemStyle),
                          SizedBox(height: 10,),
                          Text('The refresh button in the center is used to fetch new chart data from USGS',
                              textAlign: TextAlign.left,
                              style: itemStyle),
                          SizedBox(height: 10,),
                          Text('The large button expands and collapses the menu',
                              textAlign: TextAlign.left,
                              style: itemStyle)
                        ],
                      ),
                    ),
                  ),
                  Flexible(flex:1, child: VerticalDivider(color: Colors.blue,)),
                  Flexible(
                    flex: 2,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Image(
                          image: AssetImage('images/expandableButton.png'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Divider(color: Colors.blue,),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 8, bottom: 8, right: 10),
                child: Text(
                    'To remove a favorite from the favorites view, simply swipe the favorite in the list from right to left. A confirmation will appear at the bottom of the view',
                    textAlign: TextAlign.left,
                    style: itemStyle),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Image(
                    image: AssetImage('images/deleteFavorite.png'),
                  ),
                ),
              ),
              Divider(color: Colors.blue,),
            ],
          ),
        ),
      ),
    );
  }
}
