import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app1/lists/mainList.dart';
import 'package:flutter_app1/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddList extends StatefulWidget {
  @override
  _AddListState createState() => _AddListState();
}

class _AddListState extends State<AddList> {
  TextEditingController titleController = TextEditingController();
  TextEditingController desController = TextEditingController();
  final formkey = GlobalKey<FormState>();
  String imp = "notimp";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            "Add List",
            style: TextStyle(color: Colors.purple),
          )),
      floatingActionButton: Container(
        height: 60,
        width: 60,
        child: IconButton(
          onPressed: () {
            addList();
          },
          icon: Icon(
            Icons.check,
            size: 22,
            color: Colors.white,
          ),
        ),
        decoration: BoxDecoration(
            color: Colors.purple, borderRadius: BorderRadius.circular(10)),
      ),
      body: Form(
        key: formkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    controller: titleController,
                    validator: (value) {
                      if (value.length > 20) {
                        return "Title cannot be more than 20 words!";
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "List Title",
                      hintStyle: TextStyle(color: Colors.purple),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              BorderSide(color: Colors.purple, width: 2)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              BorderSide(color: Colors.purple, width: 2)),
                    ))),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: desController,
                validator: (value) {
                  if (value.length > 65) {
                    return "Description cannot be more than 65 words!";
                  }
                },
                decoration: InputDecoration(
                    hintText: "Description",
                    hintStyle: TextStyle(color: Colors.purple),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.purple, width: 2)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                            BorderSide(color: Colors.purple, width: 2))),
                keyboardType: TextInputType.multiline,
              ),
            ),
            Row(
              children: [
                Checkbox(
                    checkColor: Colors.white,
                    activeColor: Colors.purple,
                    value: imp == "imp",
                    onChanged: (value) {
                      if (imp == "imp") {
                        setState(() {
                          imp = "notimp";
                        });
                      } else {
                        setState(() {
                          imp = "imp";
                        });
                      }
                    }),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        if (imp == "imp") {
                          setState(() {
                            imp = "notimp";
                          });
                        } else {
                          setState(() {
                            imp = "imp";
                          });
                        }
                      },
                      child: Text(
                        "Mark as Important",
                        style: TextStyle(fontSize: 17, color: Colors.purple),
                      ),
                    ),
                    Icon(
                      Icons.flag,
                      color: Colors.orangeAccent,
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void addList() async {
    if (formkey.currentState.validate()) {
      String title = titleController.text.isNotEmpty
          ? titleController.text
          : "Unknown Title";

      String des =
          desController.text.isNotEmpty ? desController.text : "No Description";

      String imps = imp == "imp" ? "true" : "false";

      Map list = {"title": title, "des": des, "lists": [], "important": imps};

      mainList.add(list);
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString("mainList", json.encode(mainList));

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));

      setState(() {});
    }
  }
}
