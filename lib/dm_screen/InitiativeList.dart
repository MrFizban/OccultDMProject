import 'dart:ffi';
import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

import 'Module.dart';
import 'dart:convert';
import 'AddPartyDialog.dart';

// for son reson textfile want flexible
class InitiativeList extends StatefulWidget {
  const InitiativeList({this.module});
  final Module module;
  @override
  _InitiativeList createState() => _InitiativeList();
}

class _InitiativeList extends State<InitiativeList> {
  List<Widget> lista = [];
  dynamic _context;
  List<String> names = [];
  TextEditingController _controllerInit, _controllerName, _controllerHP;

  void initState() {
    super.initState();
    widget.module.initModule();
    widget.module.loadData();
    lista.insert(
        0,
        Row(
          children: [addButtonNewLine()],
        ));

    _controllerInit = TextEditingController();
    _controllerName = TextEditingController();
    _controllerHP = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Container(width: 550, height: 800, child: _generaLista());
  }

  void startNew() {
    _controllerInit.text = "21";
    _controllerName.text = "Mirah";
    _controllerHP.text = "0";
    setState(() {
      lista[lista.length - 1] = widget.module.createRow(
        [
          textfiledWrapper(70, "Init", _controllerInit),
          autocompleteWrapper(200, "Name", _controllerName),
          textfiledWrapper(70, "HP", _controllerHP),
          Container(
              width: 40,
              height: 40,
              child: OutlinedButton(
                onPressed: () {
                  widget.module.addNewInitiative(_controllerInit.text,
                      _controllerName.text, _controllerHP.text);
                  _resetLista();
                },
                child: Icon(
                  Icons.plus_one,
                ),
              ))
        ],
      );
    });
  }

  void _resetLista() {
    widget.module.resetLista();

    setState(() {
      lista.clear();

      for (int index = 0; index < widget.module.order.length; index++) {
        var value = widget.module.initiative[widget.module.order[index]];

        lista.add(initiativeRow(
          initiative: widget.module.order[index].toString(),
          name: value['name'].toString(),
          currentHP: value['HP'].toString(),
          maxHP: value['maxHP'].toString(),
          module: widget.module,
          refresh: _resetLista,
          index: index,
        ));
      }
      if (widget.module.order.length > 0) {
        lista.add(addControllButton());
      } else {
        lista.add(addButtonNewLine());
      }
    });
  }

  Container textfiledWrapper(
      double _width, String _label, TextEditingController _controller) {
    return Container(
        alignment: Alignment.center,
        width: _width,
        height: 20,
        child: TextField(
          controller: _controller,
          onSubmitted: (value) {
            if (_controllerName.text != null && _controllerInit.text != null) {
              widget.module.addNewInitiative(_controllerInit.text,
                  _controllerName.text, _controllerHP.text);
            } else {
              print("ERRORE");
            }
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: _label,
          ),
        ));
  }

  Container autocompleteWrapper(
      double _width, String _label, TextEditingController _controller) {
    widget.module.pg_saved.forEach((key, value) {
      names.add(key);
    });

    return Container(
        alignment: Alignment.center,
        width: _width,
        height: 20,
        child: SimpleAutoCompleteTextField(
          controller: _controller,
          suggestions: names,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: _label,
          ),
        ));
  }

  Widget addButtonNewLine() {
    return widget.module.createRow([
      OutlinedButton(
        onPressed: startNew,
        child: Text("add line"),
      ),
      OutlinedButton(
        onPressed: () {
          print(widget.module.pg_saved.toString());
        },
        child: Text("addParty"),
      )
    ]);
  }

  Widget addControllButton() {
    return widget.module.createRow([
      OutlinedButton(
        onPressed: startNew,
        child: Text("add line"),
      ),
      OutlinedButton(
        onPressed: () {
          setState(() {
            if (widget.module.turno > widget.module.order.length - 2) {
              widget.module.turno = 0;
            } else {
              widget.module.turno++;
            }
          });
          _resetLista();
        },
        child: Text("next turn"),
      ),
      OutlinedButton(
        onPressed: () {
          setState(() {
            if (widget.module.turno == 0) {
              widget.module.turno = widget.module.order.length - 1;
            } else {
              widget.module.turno--;
            }
          });
          _resetLista();
        },
        child: Text("previus turn"),
      ),
      OutlinedButton(
        onPressed: () {
          lista.clear();
          widget.module.initiative.clear();
          widget.module.order.clear();
          _resetLista();
        },
        child: Text("clear"),
      ),
      OutlinedButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AddPartyDialog(
                    module: widget.module, funzioneRefresh: _resetLista);
              });
          _resetLista();
        },
        child: Text("addParty"),
      )
    ]);
  }

  ListView _generaLista() {
    return ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: lista.length,
        itemBuilder: (BuildContext context, int index) {
          return lista[index];
        });
  }

  Future<String> test() async {
    return await Future.delayed(Duration(seconds: 5), () => "Cose");
  }
}

class initiativeRow extends StatelessWidget {
  const initiativeRow(
      {this.module,
      this.initiative,
      this.name,
      this.currentHP,
      this.maxHP,
      this.index,
      this.refresh});

  final Module module;
  final String initiative;
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
    module.turno_init = module.order[module.turno];
    if (module.turno == index) {
      color = Colors.red;
      thickness = 2;
    }

    return Padding(
        padding: EdgeInsets.all(2),
        child: Container(
            width: string_with + (number_with * 2),
            height: 30,
            decoration: BoxDecoration(
                border: Border.all(color: color, width: thickness),
                borderRadius: BorderRadius.circular(5)),
            child: Row(
              children: [
                Container(
                    width: number_with,
                    alignment: Alignment.centerRight,
                    child: Text(this.initiative)),
                Container(
                  width: 20,
                  height: 30,
                ),
                Container(
                    width: number_with,
                    alignment: Alignment.centerRight,
                    child: Text(this.name)),
                Container(
                  width: 20,
                  height: 30,
                ),
                dynamiHPTextFiled(70, this.currentHP, index),
                Container(
                  width: 10,
                  height: 30,
                ),
                Container(
                    width: string_with,
                    alignment: Alignment.centerLeft,
                    child: Text("/" + this.maxHP)),
              ],
            )));
  }

  Container dynamiHPTextFiled(double _width, String _label, int index) {
    return Container(
        alignment: Alignment.center,
        width: _width,
        height: 20,
        child: TextField(
          controller: TextEditingController(),
          onSubmitted: (value) {
            module.initiative[module.order[index]]['HP'] =
                module.calcoloDinamico(
                    module.initiative[module.order[index]]['HP'], value);
            refresh();
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: _label,
          ),
        ));
  }
}
