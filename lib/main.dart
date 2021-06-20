import 'dart:ui';

import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider_windows/path_provider_windows.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String data = "";
  TextEditingController controller = new TextEditingController();
  TextEditingController _searchcontroller = new TextEditingController();

  Future<void> _loadData() async {
    String _data = await FileUtils.readFromFile();
    FileUtils.saveToFile(_data);
    _data = await FileUtils.readFromFile();
    setState(() {
      // String _loadedData = await rootBundle.loadString('lib/log.txt');

      data = _data;

      print(data);
    });
    // return data;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
          child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            alignment: Alignment.topCenter,
            image: AssetImage('lib/blackandgreen.png'),
            fit: BoxFit.scaleDown,
          ),
        ),
      )),
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
        child: Container(
          color: Colors.transparent,
        ),
      ),
      Scaffold(
        // By defaut, Scaffold background is white
        // Set its value to transparent
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.black45,
          title: Text(''),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              child: Text("             Keylogger",
                  style: GoogleFonts.sourceCodePro(
                    shadows: [
                      Shadow(
                        color: Colors.green[300],
                        blurRadius: 10,
                      )
                    ],
                    fontSize: 60,
                    color: Colors.white,
                  )),
            ),
            SizedBox(height: 50),
            Row(
              children: [
                SizedBox(width: 300),
                Container(
                  height: 400,
                  width: 650,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    boxShadow: [
                      BoxShadow(blurRadius: 10, color: Colors.green[300])
                    ],
                  ),
                  child: SingleChildScrollView(
                      child: Text(data != null ? data.toString() : "null",
                          style: GoogleFonts.sourceCodePro(
                              fontSize: 20, color: Colors.green))),

                  // scrollDirection: Axis.vertical,
                ),
                SizedBox(
                  width: 30,
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(blurRadius: 10, color: Colors.green)
                          ], color: Colors.blueGrey),
                          child: RaisedButton(
                              color: Colors.black,
                              elevation: 12,
                              onPressed: _loadData,
                              child: Text(
                                "Refresh",
                                style: TextStyle(color: Colors.white),
                              ))),
                      SizedBox(
                        height: 57,
                      ),
                      Row(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(blurRadius: 10, color: Colors.green)
                                ],
                              ),
                              child: RaisedButton(
                                  color: Colors.black,
                                  elevation: 12,
                                  onPressed: () {
                                    _displayTextInputDialog(context);
                                    var string = data
                                        .indexOf(controller.text.toString());

                                    setState(() {
                                      data = data.substring(
                                        string,
                                      );
                                    });
                                  },
                                  child: Text(
                                    "Filter By Date",
                                    style: TextStyle(color: Colors.white),
                                  ))),
                          Container(
                              padding: EdgeInsets.only(left: 10),
                              width: 150,
                              child: TextField(
                                focusNode: FocusNode(),
                                style: TextStyle(color: Colors.white),
                                // controller: controller,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  focusColor: Colors.white,
                                  labelText: 'Enter date',
                                  // hintText: 'Enter date',
                                ),
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 57,
                      ),
                      Container(
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(blurRadius: 10, color: Colors.green)
                          ], color: Colors.blueGrey),
                          child: RaisedButton(
                              color: Colors.black,
                              elevation: 12,
                              onPressed: () {
                                return _search(context);
                              },
                              child: Text(
                                "Search",
                                style: TextStyle(color: Colors.white),
                              ))),
                      SizedBox(
                        height: 57,
                      ),
                      Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(blurRadius: 10, color: Colors.green)
                            ],
                          ),
                          child: RaisedButton(
                              color: Colors.black,
                              elevation: 12,
                              onPressed: () {},
                              child: Text(
                                "Open Log",
                                style: TextStyle(color: Colors.white),
                              ))),
                    ]),
              ],
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: _loadData, child: Icon(Icons.refresh)),
      ),
    ]);
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        barrierColor: Colors.black,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Enter Date'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  //  valueText = value;
                });
              },
              controller: controller,
              decoration: InputDecoration(hintText: "yyyy-mm-dd"),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.black,
                textColor: Colors.green,
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    var string = data.indexOf(controller.text.toString());
                    data = data.substring(
                      string,
                    );
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  Future<void> _search(BuildContext context) async {
    return showDialog(
        barrierColor: Colors.black,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Search'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  //  valueText = value;
                });
              },
              controller: _searchcontroller,
              decoration: InputDecoration(hintText: ""),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.black,
                textColor: Colors.green,
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    var index = data.indexOf(_searchcontroller.text.toString());
                    data = data.substring(
                      index,
                    );
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }
}

class FileUtils {
  static Future<File> get getFile async {
    return File('D:/flutter/app/lib/log.txt');
  }

  static Future<File> saveToFile(String data) async {
    final file = await getFile;
    return file.writeAsString(data);
  }

  static Future<String> readFromFile() async {
    try {
      final file = await getFile;
      String fileContents = await file.readAsString();
      return fileContents;
    } catch (e) {
      return "";
    }
  }
}
