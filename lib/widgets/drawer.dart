import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_wordpress/flutter_wordpress.dart' as wp;
import 'package:greenillu/routes/Routes.dart';
import 'package:greenillu/appconfig/config.dart';
//import 'package:greenilluv1/datasource/getdata.dart';
//http://dev.greenillu.com/wp-json/menus/v1/menus/mainmenu

class AppMenuDrawer extends StatelessWidget {
  static var apiPath = "/menus/mainmenu";
  static var apiFullPath = AppConfig.Appurls['wpapi'] + AppConfig.Namespaces['menu'] + apiPath;
  List menus;
  wp.WordPress wordPress = wp.WordPress(
      baseUrl: AppConfig.Appurls['baseurl']
  );

  Future<String> getMenus(data) async{
    var responseData = await http.get(apiFullPath);

    if(responseData.statusCode == 200){
      // fill our menus list with results and update state
      //setState(() {
      var resBody = json.decode(responseData.body);
      menus = resBody;
      print(menus);
      //});

      return "Success!";
    } else {
      print('Request failed with status: ${apiFullPath} ${responseData.statusCode}.');
    }
  }

  @override
  void initState() {
    //super.initState();
    this.getMenus("");
  }

  @override
  Widget build(BuildContext context) {
    //this.getMenus("");
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(),
          _createDrawerItem(
              icon: Icons.contacts,
              text: 'Products',
              url: apiFullPath,
              onTap: () =>
                  Navigator.pushReplacementNamed(context, Routes.products)),
          _createDrawerItem(
              icon: Icons.event,
              text: 'Login',
              url: AppConfig.Appurls['baseurl'],
              onTap: () =>
                  Navigator.pushReplacementNamed(context, Routes.login)),
          /* _createDrawerItem(
              icon: Icons.note,
              text: 'Notes',
              onTap: () =>
                  Navigator.pushReplacementNamed(context, Routes.notes)),*/
          Divider(),
          _createDrawerItem(icon: Icons.collections_bookmark, text: 'Steps'),
          _createDrawerItem(icon: Icons.face, text: 'Authors'),
          _createDrawerItem(
              icon: Icons.account_box, text: 'Flutter Documentation'),
          _createDrawerItem(icon: Icons.stars, text: 'Useful Links'),
          Divider(),
          _createDrawerItem(icon: Icons.bug_report, text: 'Report an issue'),
          ListTile(
            title: Text('0.0.1'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _createHeader() {
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('res/images/drawer_header_background.png'))),
        child: Stack(children: <Widget>[
          Positioned(
              bottom: 12.0,
              left: 16.0,
              child: Text("Flutter Step-by-Step",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500))),
        ]));
  }
//Widget
  _createDrawerItem(
      {IconData icon, String text, String url, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}