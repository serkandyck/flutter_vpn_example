import 'package:flutter/material.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({Key key}) : super(key: key);


  Widget bodyData() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.ac_unit,
              size: 100.0,
              color: Colors.blue,
            ),
            SizedBox(
              height: 20.0,
            ),
            Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "title",
          style: TextStyle(
              fontSize: 17.0, fontWeight: FontWeight.w800, color: Colors.black),
        ),
        SizedBox(
          height: 5.0,
        ),
        Text(
          "subtitle",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 14.0, fontWeight: FontWeight.normal, color: Colors.black),
        ),
      ],
    )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: new AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: (){Navigator.pop(context,true);}
        ),
        backgroundColor: Colors.blue[600],
        title: Text("Not found title"),
      ),
      body: bodyData(),
    );
  }
}