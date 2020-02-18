import 'package:flutter/material.dart';
import 'package:appcenter/appcenter.dart';
import 'package:appcenter_analytics/appcenter_analytics.dart';
import 'package:appcenter_crashes/appcenter_crashes.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/foundation.dart' show TargetPlatform;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final ios = defaultTargetPlatform == TargetPlatform.iOS;
  String appSecret = ios
      ? "4cb4478e-9803-92cf-02ef-00f272f9768d"
      : "7bf557b6-6739-028f-b83e-ba192d3f7972";

  await AppCenter.start(appSecret, [AppCenterAnalytics.id, AppCenterCrashes.id]);

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
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String _installId = 'Unknown';
  bool _areAnalyticsEnabled = false, _areCrashesEnabled = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  initPlatformState() async {
    if(!mounted) return;

    var installId = await AppCenter.installId;
    var areAnalyticsEnabled = await AppCenterAnalytics.isEnabled;
    var areCrashesEnabled = await AppCenterCrashes.isEnabled;

    setState(() {
      _installId = installId;
      _areAnalyticsEnabled = areAnalyticsEnabled;
      _areCrashesEnabled = areCrashesEnabled;
    });



  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('AppCenter plugin example app'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text('Install identifier:\n $_installId'),

          Text('Analytic: $_areAnalyticsEnabled'),

          Text('Crashes: $_areCrashesEnabled'),

          RaisedButton(
            onPressed: AppCenterCrashes.generateTestCrash,
            child: Text('Generate test crash'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text('Send events'),

              IconButton(
                icon: Icon(Icons.map),
                tooltip: 'map',
                onPressed: () {
                  AppCenterAnalytics.trackEvent("map");
                },
              ),

              IconButton(
                icon: Icon(Icons.casino),
                tooltip: 'casino',
                onPressed: (){
                  AppCenterAnalytics.trackEvent("casino", {"dollars": "10"});
                },
              )
            ],
          )
        ],
      ),

    );
  }


}
