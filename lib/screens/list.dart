import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app1/lists/mainList.dart';
import 'package:flutter_app1/lists/tasks.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListsPage extends StatefulWidget {
  final appbar;
  final index;

  ListsPage({this.appbar, this.index});
  @override
  _ListsPageState createState() => _ListsPageState();
}

class _ListsPageState extends State<ListsPage> {
  @override
  void initState() {
    listes = mainList[widget.index]['lists'];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController listController = TextEditingController();
    return Scaffold(
      backgroundColor: listes.isEmpty ? Colors.white : Colors.grey[100],
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: popselected,
            itemBuilder: (BuildContext context) {
              return {'clear completed task'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
        backgroundColor: Colors.purple,
        elevation: 0,
        title: Text(widget.appbar),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          listes.isNotEmpty
              ? Expanded(
                  child: Container(
                    height: 130.0 * listes.length,
                    child: ListView.builder(
                      itemCount: listes.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTitles(
                          text: listes[index]['text'],
                          done: listes[index]['done'],
                          mindex: widget.index,
                          tindex: index,
                          title: widget.appbar,
                        );
                      },
                    ),
                  ),
                )
              : Expanded(
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/nodata.png",
                        width: 300,
                      ),
                      Text("No Tasks Created!",
                          style: TextStyle(
                            fontSize: 20,
                          ))
                    ],
                  )),
                ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: listController,
              decoration: InputDecoration(
                hintText: "Add Task",
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.purple,
                    child: IconButton(
                      onPressed: () {
                        addLists(listController.text);
                      },
                      icon: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.purple, width: 2)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.purple, width: 2)),
              ),
            ),
          )
        ],
      ),
    );
  }

  void addLists(String listname) async {
    if (listname.length < 30 && listname.isNotEmpty) {
      Map list = {"text": listname, "done": "false"};
      listes.add(list);
      setState(() {
        mainList[widget.index]['lists'] = listes;
      });
      print(mainList[widget.index]);
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString("mainList", json.encode(mainList));
    } else {}
  }

  void popselected(String value) async {
    List toDel = [];
    List toShow = [];
    if (value == "clear completed task") {
      for (int i = 0; i < listes.length; i++) {
        if (listes[i]['done'] == "true") {
          toDel.add(listes[i]);
        } else {
          toShow.add(listes[i]);
        }
      }
      setState(() {
        listes.clear();
        listes = toShow;
        mainList[widget.index]['lists'] = listes;
      });
    }
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("mainList", json.encode(mainList));

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ListsPage(
                  appbar: widget.appbar,
                  index: widget.index,
                )));
  }
}

class ListTitles extends StatefulWidget {
  final text;
  final done;
  final mindex;
  final tindex;
  final title;

  ListTitles({this.done, this.text, this.mindex, this.tindex, this.title});
  @override
  _ListTitlesState createState() => _ListTitlesState();
}

class _ListTitlesState extends State<ListTitles> {
  String done;
  TextDecoration textDec;

  @override
  void initState() {
    done = widget.done;
    done == "true" ? textDec = TextDecoration.lineThrough : TextDecoration.none;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () async {
          if (done == "false") {
            setState(() {
              done = "true";
              textDec = TextDecoration.lineThrough;
              mainList[widget.mindex]['lists'][widget.tindex]["done"] = "true";
            });
            SharedPreferences pref = await SharedPreferences.getInstance();
            pref.setString("mainList", json.encode(mainList));
          } else {
            setState(() {
              done = "false";
              textDec = TextDecoration.none;
              mainList[widget.mindex]['lists'][widget.tindex]["done"] = "false";
            });
            SharedPreferences pref = await SharedPreferences.getInstance();
            pref.setString("mainList", json.encode(mainList));
          }
        },
        child: Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurRadius: 5,
                  color: Colors.black45,
                  spreadRadius: 1,
                ),
              ],
              border: Border.all(color: Colors.purple, width: 2),
              borderRadius: BorderRadius.circular(10),
              color: Colors.white),
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Checkbox(
                  activeColor: Colors.purple,
                  value: done == "true",
                  onChanged: (value) async {
                    if (done == "false") {
                      setState(() {
                        done = "true";
                        textDec = TextDecoration.lineThrough;
                        mainList[widget.mindex]['lists'][widget.tindex]
                            ["done"] = "true";
                      });
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      pref.setString("mainList", json.encode(mainList));
                    } else {
                      setState(() {
                        done = "false";
                        textDec = TextDecoration.none;
                        mainList[widget.mindex]['lists'][widget.tindex]
                            ["done"] = "false";
                      });
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      pref.setString("mainList", json.encode(mainList));
                    }
                  }),
              Expanded(
                child: Text(widget.text,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      decoration: textDec,
                    )),
              ),
              IconButton(
                onPressed: () async {
                  setState(() {
                    mainList[widget.mindex]['lists'].removeAt(widget.tindex);
                  });
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  pref.setString("mainList", json.encode(mainList));
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ListsPage(
                                appbar: widget.title,
                                index: widget.mindex,
                              )));
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.red[700],
                ),
              )
            ],
          )),
        ),
      ),
    );
  }
}
