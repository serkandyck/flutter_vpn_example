import 'package:flutter/material.dart';
import 'package:vpnlab/pages/main_page.dart';
import 'package:vpnlab/pages/notfound/notfound_page.dart';

class App extends StatelessWidget {

  var materialApp = MaterialApp(
    title: "VPNLab - Unlimited, A Fast, Free VPN Proxy",
     theme: ThemeData(
        primaryColor: Colors.blue[600],
        primarySwatch: Colors.blue
      ),
      debugShowCheckedModeBanner: false,
      showPerformanceOverlay: false,
    
      home: MainPage(),
      routes: <String, WidgetBuilder>{
      },
      onUnknownRoute: (RouteSettings rs) => new MaterialPageRoute(
        builder: (context) => new NotFoundPage()
      )
  );
  @override
  Widget build(BuildContext context) {
    return materialApp;
  }
}