import 'package:flutter/material.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.ac_unit,color: Colors.transparent,),
        title: Text('消息'),
        centerTitle: true,
      ),
      body: Container(
          child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.not_listed_location,
              size: 64,
              color: Theme.of(context).highlightColor,
            ),
            Text(
              '暂时没有消息',
              style: TextStyle(color: Theme.of(context).highlightColor,fontSize: 16.0),
            )
          ],
        ),
      )),
    );
  }
}
