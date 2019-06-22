import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:vpnlab/models/server.dart';
import 'package:vpnlab/utils/utils.dart';
import 'package:flutter_vpn/flutter_vpn.dart';
import 'package:animator/animator.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:vpnlab/widgets/main_drawer.dart';
import 'package:vpnlab/widgets/profile_tile.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String testDevice = 'test-device-id';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null,
  );

  InterstitialAd _interstitialAd;

  final GlobalKey _menuKey = new GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  final bgColorDisconnected = [Color(0xFF000000), Color(0xFFDD473D)];
  final bgColorConnected = [Color(0xFF000000), Color(0xFF37AC53)];
  final bgColorConnecting = [Color(0xFF000000), Color(0xFFCCAD00)];

  bool userTurbo = false;
  bool rewardAdLoaded = false;

  var state = FlutterVpnState.disconnected;
  var charonState = CharonVpnState.down;

  final List<Server> _allServers = Server.allServers();

  SharedPreferences sharedPreferences;


  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
      adUnitId: InterstitialAd.testAdUnitId,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event $event");
        setState(() {
          if (event == MobileAdEvent.closed) {
            _interstitialAd?.dispose();
            _interstitialAd = createInterstitialAd()..load();
          }
          if (event == MobileAdEvent.failedToLoad) {
            _interstitialAd?.dispose();
            _interstitialAd = createInterstitialAd()..load();
          }
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;
      var turboStringEndTime = sharedPreferences.getString("turbo");
      DateTime turboEndTime = DateTime.parse(turboStringEndTime);
      DateTime now = DateTime.now();

      // will be null if never previously saved
      if (turboStringEndTime == null) {
        userTurbo = false;
        persist(userTurbo);
      } else {
        if(turboEndTime.isAfter(now)) {
          userTurbo = false;
          persist(userTurbo);
        } else {
          userTurbo = true;
          persist(userTurbo);
        }
      }
      setState(() {});
    });
    FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
    RewardedVideoAd.instance.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      print("RewardedVideoAd event $event");
      switch (event) {
        case RewardedVideoAdEvent.loaded:
          setState(() {
            rewardAdLoaded = true;
          });
          break;
        case RewardedVideoAdEvent.failedToLoad:
          break;
        case RewardedVideoAdEvent.completed:
          break;
        case RewardedVideoAdEvent.started:
          break;
        case RewardedVideoAdEvent.opened:
          break;
        case RewardedVideoAdEvent.closed:
          break;
        case RewardedVideoAdEvent.leftApplication:
          break;
        case RewardedVideoAdEvent.rewarded:
          _getTurbo();
          break;
      }
    };
    _interstitialAd = createInterstitialAd()..load();
    FlutterVpn.prepare();
    FlutterVpn.onStateChanged.listen((s) {
      if (s == FlutterVpnState.connected) {
        _interstitialAd?.show();
      }
      if (s == FlutterVpnState.disconnected) {
        _interstitialAd?.show();
      }
      setState(() {
        state = s;
      });
    });
    RewardedVideoAd.instance.load(
        adUnitId: RewardedVideoAd.testAdUnitId, targetingInfo: targetingInfo);
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

    void persist(bool value) {
    setState(() {
      userTurbo = value;
    });
  }

  _getTurbo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var now = DateTime.now();
    var turboEndTime = now.add(Duration(hours: 5));
    await prefs.setString('turbo', turboEndTime.toString());
    persist(true);
  }

  Future<Null> _fetchPrefencesTurbo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      if (preferences.getString("turbo") != null) {
        var stringTime = preferences.getString('turbo');
        DateTime turboEndTime = DateTime.parse(stringTime);
        print(turboEndTime.isAfter(DateTime.now()));
        if(turboEndTime.isAfter(DateTime.now())) {
          userTurbo = false;
        }
        userTurbo = true;
      } else {
        userTurbo = false;
      }
    });
  }

  Future<bool> getTurboStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("turbo") != null) {
        var stringTime = prefs.getString('turbo');
        DateTime turboEndTime = DateTime.parse(stringTime);
        print(turboEndTime.isAfter(DateTime.now()));
        if(DateTime.now().isAfter(turboEndTime)) {
          return false;
        } else {
          return true;
        }
    } else {
      return false;
    }
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

  void changeServer(premium) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.fromTop,
      isCloseButton: true,
      isOverlayTapDismiss: true,
      descStyle: TextStyle(fontSize: 12.0),
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: TextStyle(
        color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold
      ),
    );
    if (premium) {
      if (userTurbo) {
        // server premium kullanıcı turbo
      } else {
        // server premium kullanıcı turbo değil
        if (rewardAdLoaded) {
          Alert(
            style: alertStyle,
            context: context,
            type: AlertType.info,
            title: "FREE 5 HOUR TURBO",
            desc: "Watch Video\nWin 5 Hour Free Turbo",
            buttons: [
              DialogButton(
                child: Text(
                  "Watch Video",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                onPressed: () => RewardedVideoAd.instance.show(),
                width: 120,
              )
            ],
          ).show();
        } else {
          RewardedVideoAd.instance.load(
              adUnitId: RewardedVideoAd.testAdUnitId,
              targetingInfo: targetingInfo);
          Alert(
            style: alertStyle,
            context: context,
            type: AlertType.error,
            title: "RFLUTTER ALERT",
            desc: "Flutter is more awesome with RFlutter Alert.",
            buttons: [
              DialogButton(
                child: Text(
                  "COOL",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () => RewardedVideoAd.instance.show(),
                width: 120,
              )
            ],
          ).show();
        }
      }
    } else {
      // server premium değil
    }
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) => Material(
            clipBehavior: Clip.antiAlias,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                header(),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: false,
                    itemCount: _allServers.length,
                    itemBuilder: (context, i) => ListTile(
                        leading: Image(
                          height: 30,
                          image: AssetImage(_allServers[i].flag),
                        ),
                        trailing: radioBuilder(_allServers[i].premium),
                        title: Text(
                          _allServers[i].country,
                        ),
                        subtitle: _allServers[i].premium
                            ? Text(
                                "Turbo Server",
                                style: TextStyle(color: Colors.orange),
                              )
                            : Text("Free Server"),
                        onTap: () {
                          changeServer(_allServers[i].premium);
                        }),
                  ),
                ),
              ],
            )));
  }

  Widget radioBuilder(premium) =>
       premium && !userTurbo ? Icon(Icons.lock) : Icon(Icons.arrow_right);

  Widget header() => userTurbo ? Container(height: 0) : Container(
        height: 55,
        child: Ink(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.cyan.shade600, Colors.blue.shade900])),
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Image(
                  height: 30,
                  image: AssetImage("assets/turbo.png"),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ProfileTile(
                    title: "GET FREE TURBO NOW",
                    subtitle: "Watch Video, get 5 hours turbo",
                    textColor: Colors.white,
                  ),
                ),
                new RaisedButton(
                  child: const Text('GET FREE TURBO',
                      style: TextStyle(fontSize: 10)),
                  color: Colors.white,
                  elevation: 2.0,
                  splashColor: Colors.blueGrey,
                  onPressed: () {
                    RewardedVideoAd.instance.show();
                  },
                ),
              ],
            ),
          ),
        ),
      );

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
          bottomNavigationBar: FutureBuilder<bool>(
            future: getTurboStatus(),
            builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                  default:
                    if (snapshot.hasError)
                      return new Text('Error: ${snapshot.error}');
                    else
                      print(snapshot.data);
                      return header();
                }
            }
          ),
          body: buildUi(context)),
    );
  }
}
