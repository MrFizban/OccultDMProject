import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/services.dart';

import 'Module.dart';
import 'PgWindow.dart';

// for son reson textfile want flexible
class PartyList extends StatefulWidget {
  const PartyList({this.module});
  final Module module;
  @override
  _PartyList createState() => _PartyList();
}

class _PartyList extends State<PartyList> {
  List<Widget> lista = [];
  Widget home;
  void initState() {
    super.initState();
    widget.module.loadData();
    lista.insert(
        0,
        Row(
          children: [
            OutlinedButton(
              child: Text("Load Party"),
              onPressed: () {
                setState(() {
                  _resetLista();
                });
              },
            )
          ],
        ));
  }

  void _resetLista() {
    setState(() {
      lista.clear();
      int index = 0;

      widget.module.pg_saved.forEach((key, value) {
        lista.insert(
            index,
            partyRow(
              player: value['player'].toString(),
              name: key,
              currentHP: value['HP'].toString(),
              maxHP: value['maxHP'].toString(),
              module: widget.module,
              refresh: _resetLista,
              index: index,
            ));

        index++;
      });
    });
  }

  void _generateLista() {
    lista.clear();
    int index = 0;

    widget.module.pg_saved.forEach((key, value) {
      lista.insert(
          index,
          partyRow(
            player: value['player'].toString(),
            name: key,
            currentHP: value['HP'].toString(),
            maxHP: value['maxHP'].toString(),
            module: widget.module,
            refresh: _resetLista,
            index: index,
          ));

      index++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
          width: 550,
          height: 220,
          child: FutureBuilder(
            future: widget.module.future_pg_saved,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                _generateLista();
                print("lista: \t" + lista.toString());
                return ListView.builder(
                  itemCount: widget.module.pg_saved.length,
                  itemBuilder: (context, index) => lista[index],
                );
              } else if (snapshot.hasError) {
                return Container(
                  child: Text("ERROR"),
                );
              } else {
                return Container(
                  child: Text("Loading"),
                );
              }
            },
          )),
      Row(
        children: [
          OutlinedButton(
            child: Text("Premi"),
            onPressed: () => showDialog(
                context: context,
                builder: (_) {
                  return PgWindow(
                      module: widget.module, funzioneRefresh: _resetLista);
                }),
          )
        ],
      )
    ]);
  }
}

class partyRow extends StatelessWidget {
  const partyRow(
      {this.module,
      this.player,
      this.name,
      this.currentHP,
      this.maxHP,
      this.index,
      this.refresh});

  final Module module;
  final String player;
  final String name;
  final String currentHP;
  final String maxHP;
  final int index;
  final Function refresh;

  @override
  Widget build(BuildContext context) {
    const double string_with = 120;
    const double number_with = 70;

    Color color = Colors.black;
    double thickness = 0.5;

    return Padding(
        padding: EdgeInsets.all(2),
        child: Container(
            width: string_with + (number_with * 2),
            height: 30,
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
                border: Border.all(color: color, width: thickness),
                borderRadius: BorderRadius.circular(5)),
            child: Row(
              children: [
                Container(
                    width: number_with,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.all(3),
                    child: Text(this.player)),
                Container(
                  width: 20,
                  height: 30,
                ),
                Container(
                    width: 90,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        border: Border.all(color: color, width: thickness),
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(this.name)),
                Container(
                  width: 20,
                  height: 30,
                ),
                Container(
                    width: 40,
                    alignment: Alignment.centerRight,
                    decoration: BoxDecoration(
                        border: Border.all(color: color, width: thickness),
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(this.currentHP)),
                Container(
                    width: 40,
                    alignment: Alignment.centerLeft,
                    child: Text("/" + this.maxHP)),
              ],
            )));
  }
}
