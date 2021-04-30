import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

import 'Module.dart';
import 'AddPartyDialog.dart';

// for son reson textfile want flexible
class MonsterList extends StatefulWidget {
  const MonsterList({this.module});
  final Module module;
  @override
  _MonsterList createState() => _MonsterList();
}

class _MonsterList extends State<MonsterList> {
  List<Widget> lista = [];

  void initState() {
    super.initState();
    lista.insert(
        0,
        Row(
          children: [],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 500,
        height: 2,
        child: ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: lista.length,
            itemBuilder: (BuildContext context, int index) {
              return lista[index];
            }));
  }
}
