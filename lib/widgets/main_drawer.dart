import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              "test",
              style: TextStyle(color: Colors.white),
            ),
            accountEmail: Text(
              "test",
              style: TextStyle(color: Colors.white),
            ),
          ),
          new ListTile(
            onTap: () { },
            title: Text(
              "Gösterge Paneli",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16.0),
            ),
            leading: Icon(
              Icons.dashboard,
              color: Colors.red,
            ),
          ),
          Divider(),
          new ListTile(
            onTap: () { },
            title: Text(
              "Uygulama Ayarları",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16.0),
            ),
            leading: Icon(
              Icons.ac_unit,
              color: Colors.indigo,
              size: 20.0,
            ),
          ),
          Divider(),
          new ListTile(
            onTap: () { },
            title: Text(
              "Çıkış Yap",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16.0),
            ),
            leading: Icon(
              Icons.ac_unit,
              color: Colors.red,
              size: 20.0,
            ),
          ),
        ],
      ),
    );
  }
}
