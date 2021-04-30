import 'package:flutter/material.dart';
import 'InitiativeList.dart';
import 'PartyList.dart';
import 'MonsterList.dart';

import 'Module.dart';

class DMSreen extends StatefulWidget {
  @override
  _DMSreen createState() => _DMSreen();
}

class _DMSreen extends State<DMSreen> {
  Module _module;
  void initState() {
    _module = Module();
    _module.initModule();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'DM Screen',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
            appBar: AppBar(
              title: Text('Initiative List'),
            ),
            body: Row(children: [
              InitiativeList(
                module: _module,
              ),
              Column(
                children: [
                  PartyList(
                    module: _module,
                  ),
                  MonsterList()
                ],
              )
            ])));
  }
}
