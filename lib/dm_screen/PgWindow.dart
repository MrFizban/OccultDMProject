import 'dart:ffi';
import 'dart:collection';
import 'dart:io';

import 'Module.dart';

import 'package:flutter/material.dart';

class PgWindow extends StatefulWidget {
  final Module module;

  final Function funzioneRefresh;
  PgWindow({Key key, this.module, this.funzioneRefresh}) : super(key: key);

  @override
  _PgWindow createState() => _PgWindow();
}

class _PgWindow extends State<PgWindow> {
  List<Widget> attackWidget = [];
  TextEditingController player, name, hp, maxHP, ca, rif, cos, sag;
  List<List<TextEditingController>> atacckController;

  @override
  Widget build(BuildContext context) {
    return showMyDialog(context);
  }

  void initState() {
    attackWidget.add(OutlinedButton(
        onPressed: () => _addAttack(), child: Text("add attack")));
    player = TextEditingController();
    name = TextEditingController();
    hp = TextEditingController();
    maxHP = TextEditingController();
    ca = TextEditingController();
    rif = TextEditingController();
    cos = TextEditingController();
    sag = TextEditingController();
  }

  Widget showMyDialog(dynamic context) {
    List<String> temp = [];
    widget.module.pg_saved.forEach((key, value) => temp.add(key));

    return AlertDialog(
      title: Text('PG Little sheet'),
      content: _contenuto(),
      actions: <Widget>[
        OutlinedButton(
          child: Text('Save'),
          onPressed: () => _savePG(),
        ),
        OutlinedButton(
          child: Text('Cancell'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget _contenuto() {
    return Container(
      width: 350,
      height: 300,
      padding: EdgeInsets.all(5),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 160,
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: "Player"),
                ),
              ),
              Container(
                width: 10,
              ),
              Container(
                width: 160,
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: "Name"),
                ),
              )
            ],
          ),
          Container(
            height: 10,
          ),
          Row(
            children: [
              Container(
                width: 5,
              ),
              Container(
                width: 85,
                height: 40,
                child: TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: "HP"),
                ),
              ),
              Container(
                width: 20,
              ),
              Container(
                width: 85,
                height: 40,
                child: TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: "maxHP"),
                ),
              ),
              Container(
                width: 40,
              ),
              Container(
                width: 75,
                height: 40,
                child: TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: "CA"),
                ),
              ),
              Container(
                width: 5,
              ),
            ],
          ),
          Container(
            height: 10,
          ),
          Row(
            children: [
              Container(
                width: 5,
              ),
              Container(
                width: 75,
                height: 40,
                child: TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: "Rif"),
                ),
              ),
              Container(
                width: 40,
              ),
              Container(
                width: 75,
                height: 40,
                child: TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: "Cos"),
                ),
              ),
              Container(
                width: 40,
              ),
              Container(
                width: 75,
                height: 40,
                child: TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: "Sag"),
                ),
              ),
              Container(
                width: 5,
              ),
            ],
          ),
          Container(
            height: 10,
          ),
          Container(
            alignment: Alignment.topLeft,
            child: Column(
              children: attackWidget,
            ),
          ),
        ],
      ),
    );
  }

  void _addAttack() {
    attackWidget.insert(
        attackWidget.length - 1,
        Container(
          padding: EdgeInsets.all(5),
          height: 40,
          width: 330,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0.5),
          ),
          child: Row(
            children: [
              Container(
                width: 70,
                height: 40,
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: "+hit"),
                ),
              ),
              Container(
                width: 5,
              ),
              Container(
                width: 70,
                height: 40,
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: "dice"),
                ),
              ),
              Container(
                width: 5,
              ),
              Container(
                width: 160,
                height: 40,
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: "desc"),
                ),
              ),
            ],
          ),
        ));
    setState(() {});
  }

  void _savePG() {
    widget.module.pg_saved[name.text] = {
      "player": player.text,
      "HP": hp,
      "maxHP": maxHP,
      "CA": ca,
      "Rif": rif,
      "Cos": cos,
      "Sag": sag,
    };

    print(widget.module.pg_saved);
  }
}
