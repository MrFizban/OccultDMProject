import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'dart:io';

class Module {
  Map<double, Map<String, dynamic>> initiative;
  Map<String, dynamic> pg_saved;
  Future<Map<String, dynamic>> future_pg_saved;
  List<double> order = [];

  int turno = 0;
  double turno_init = 0;

  void loadData() async {
    future_pg_saved = readPG();
    pg_saved = await future_pg_saved;
    print("ho caricato i PGFILE");
    await getAllEncounter();
  }

  void initModule() {
    initiative = Map<double, Map<String, dynamic>>();
  }

  num calcoloDinamico(num oldValue, String newValue) {
    if (newValue[0] == "+" || newValue[0] == "-") {
      if (newValue[0] == "+") {
        oldValue += int.parse(newValue.substring(1));
      }
      if (newValue[0] == "-") {
        oldValue -= int.parse(newValue.substring(1));
      }
    } else {
      oldValue = int.parse(newValue);
    }

    return oldValue;
  }

  void resetLista() {
    order = [];
    initiative.forEach((key, value) {
      order.add(key);
    });

    order.sort((b, a) => a.compareTo(b));
  }

  void addNewInitiative(String init, String name, String hp) {
    _addNewInitiative(double.parse(init), name, int.parse(hp));
  }

  void _addNewInitiative(double key, String name, int hp) {
    print(pg_saved);
    if (initiative.containsKey(key)) {
      double temp = double.parse((key + 0.01).toStringAsFixed(3));
      _addNewInitiative(temp, name, hp);
    } else {
      initiative[key] = new Map<String, dynamic>();
      initiative[key]["name"] = name;
      if (hp == 0) {
        if (pg_saved.containsKey(name)) {
          initiative[key]["HP"] = int.parse(pg_saved[name]['HP']);
          initiative[key]["maxHP"] = int.parse(pg_saved[name]['maxHP']);
        } else {
          initiative[key]["HP"] = 0;
          initiative[key]["maxHP"] = 0;
        }
      } else {
        initiative[key]["HP"] = hp;
        initiative[key]["maxHP"] = hp;
      }
    }
  }

  Future<String> get _localPath async {
    var directory = await getApplicationDocumentsDirectory();
    return join(directory.path, "OccultDMProject");
  }

  Future<List<FileSystemEntity>> dirContents(Directory dir) {
    var files = <FileSystemEntity>[];
    var completer = Completer<List<FileSystemEntity>>();
    var lister = dir.list(recursive: false);
    lister.listen((file) => files.add(file),
        // should also register onError
        onDone: () => completer.complete(files));
    return completer.future;
  }

  Future<Map<String, String>> getAllEncounter() async {
    var myDir = new Directory(await _localPath);
    Map<String, String> temp = Map<String, String>();
    var lister = myDir.list(recursive: false);
    lister.listen((file) {
      List<String> stringa = file.toString().split("/");
      var name = stringa[stringa.length - 1];
      temp[name] = file.toString();
    });
    return temp;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/party.json');
  }

  Future<Map<String, dynamic>> readPG() async {
    try {
      final file = await _localFile;

      // Read the file.
      String contents = await file.readAsString();
      return await jsonDecode(contents);
    } catch (e) {
      // If encountering an error, return 0.
      return null;
    }
  }

  Future<File> writePG(Map<String, dynamic> pg) async {
    final file = await _localFile;

    // Write the file.
    return file.writeAsString(json.encode(pg));
  }

  Widget createRow(List<Widget> list) {
    List<Widget> temp = [];
    list.forEach((element) {
      temp.add(Padding(
        padding: EdgeInsets.all(5),
        child: element,
      ));
    });
    return Padding(
      padding: EdgeInsets.all(5),
      child: Row(
        children: temp,
      ),
    );
  }

  void stampaPercorso() {
    readPG();
  }
}
