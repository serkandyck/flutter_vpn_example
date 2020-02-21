import 'package:flutter/material.dart';
import 'package:vpnlab/models/server.dart';
import 'package:vpnlab/utils/utils.dart';
import 'package:flutter_vpn/flutter_vpn.dart';
import 'package:animator/animator.dart';
import 'package:vpnlab/widgets/main_drawer.dart';
import 'package:vpnlab/widgets/profile_tile.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey _menuKey = new GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  final bgColorDisconnected = [Color(0xFF000000), Color(0xFFDD473D)];
  final bgColorConnected = [Color(0xFF000000), Color(0xFF37AC53)];
  final bgColorConnecting = [Color(0xFF000000), Color(0xFFCCAD00)];

  var state = FlutterVpnState.disconnected;

  final List<Server> _allServers = Server.allServers();

  @override
  void initState() {
    super.initState();
    FlutterVpn.prepare();
    FlutterVpn.onStateChanged.listen((s) {
      if (s == FlutterVpnState.connected) {
        // Device Connected
      }
      if (s == FlutterVpnState.disconnected) {
        // Device Disconnected
      }
      setState(() {
        state = s;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void connectVpn() {
    if (state == FlutterVpnState.connected) {
      FlutterVpn.disconnect();
    } else {
      FlutterVpn.simpleConnect(
          "35.229.109.225.sslip.io", "tensai", "tensai321@");
    }
    print("connect");
  }

  void changeServer() {
    
  }

  void _showModalBottomSheet(BuildContext context) {
    
  }

  Widget serverConnection(context) {
    return new GestureDetector(
      onTap: () {
        _showModalBottomSheet(context);
      },
      child: new Row(
        children: <Widget>[
          new Container(
            width: screenAwareSize(30.0, context),
            height: screenAwareSize(30.0, context),
            decoration: new BoxDecoration(
              // Circle shape
              shape: BoxShape.circle,
              color: Colors.white,
              // The border you want
              border: new Border.all(
                width: screenAwareSize(2.0, context),
                color: Colors.white,
              ),
              // The shadow you want
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/performance.png'),
                  // ...
                ),
                // ...
              ),
            ),
          ),
          SizedBox(width: screenAwareSize(10.0, context)),
          Text(
            "Fastest Server",
            style: TextStyle(
                color: Colors.white, fontFamily: "Montserrat-SemiBold"),
          ),
          SizedBox(width: screenAwareSize(5.0, context)),
          Icon(Icons.arrow_drop_up, color: Colors.white)
        ],
      ),
    );
  }

  Widget buildUi(BuildContext context) {
    if (state == FlutterVpnState.connected) {
      //bağlı
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "TAP TO\nTURN OFF VPN",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Montserrat-SemiBold",
                    fontSize: 16.0),
              ),
              SizedBox(height: screenAwareSize(35.0, context)),
              SizedBox(
                width: screenAwareSize(190.0, context),
                height: screenAwareSize(190.0, context),
                child: FloatingActionButton(
                  elevation: 0,
                  backgroundColor: Colors.green,
                  onPressed: connectVpn,
                  child: new Icon(Icons.power_settings_new,
                      size: screenAwareSize(150.0, context)),
                ),
              ),
              SizedBox(height: screenAwareSize(50.0, context)),
              serverConnection(context),
              SizedBox(height: screenAwareSize(30.0, context)),
              Text(
                "YOUR INTERNET CONNECTION\nIS PROTECTED",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Montserrat-SemiBold",
                    fontSize: 12.0),
              ),
              SizedBox(height: screenAwareSize(40.0, context)),
            ],
          ))
        ],
      );
    } else if (state == FlutterVpnState.connecting) {
      // bağlanıyor
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Animator(
                duration: Duration(seconds: 2),
                repeats: 0,
                builder: (anim) => FadeTransition(
                      opacity: anim,
                      child: Text(
                        "CONNECTING",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Montserrat-SemiBold",
                            fontSize: 20.0),
                      ),
                    ),
              ),
              SizedBox(height: screenAwareSize(35.0, context)),
              SpinKitRipple(
                color: Colors.white,
                size: 190.0,
              ),
              SizedBox(height: screenAwareSize(50.0, context)),
              serverConnection(context),
              SizedBox(height: screenAwareSize(30.0, context)),
              Text(
                "CONNECTING VPN SERVER",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Montserrat-SemiBold",
                    fontSize: 12.0),
              ),
              SizedBox(height: screenAwareSize(40.0, context)),
            ],
          ))
        ],
      );
    } else {
      // bağlı değil
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "TAP TO\nTURN ON VPN",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Montserrat-SemiBold",
                    fontSize: 16.0),
              ),
              SizedBox(height: screenAwareSize(35.0, context)),
              SizedBox(
                width: screenAwareSize(190.0, context),
                height: screenAwareSize(190.0, context),
                child: FloatingActionButton(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  onPressed: connectVpn,
                  child: new Icon(Icons.power_settings_new,
                      color: Colors.green,
                      size: screenAwareSize(150.0, context)),
                ),
              ),
              SizedBox(height: screenAwareSize(50.0, context)),
              serverConnection(context),
              SizedBox(height: screenAwareSize(30.0, context)),
              Text(
                "YOUR INTERNET CONNECTION\nISN'T PROTECTED",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Montserrat-SemiBold",
                    fontSize: 12.0),
              ),
              SizedBox(height: screenAwareSize(40.0, context)),
            ],
          ))
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("assets/map-pattern.png"),
            fit: BoxFit.contain,
          ),
          gradient: LinearGradient(
              colors: state == FlutterVpnState.connected
                  ? bgColorConnected
                  : (state == FlutterVpnState.connecting
                      ? bgColorConnecting
                      : bgColorDisconnected),
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              tileMode: TileMode.clamp)),
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          drawer: MainDrawer(),
          appBar: AppBar(
            iconTheme: new IconThemeData(color: Colors.white),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            title: Text("VPNLab",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: screenAwareSize(18.0, context),
                    fontFamily: "Montserrat-Bold")),
            centerTitle: true,
          ),
          body: buildUi(context)),
    );
  }
}
