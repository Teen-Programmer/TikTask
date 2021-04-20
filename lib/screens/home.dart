import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app1/lists/mainList.dart';
import 'package:flutter_app1/screens/addList.dart';
import 'package:flutter_app1/screens/list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    getList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: Container(
          height: 60,
          width: 60,
          child: IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => AddList()));
            },
            icon: Icon(
              Icons.add,
              size: 22,
              color: Colors.white,
            ),
          ),
          decoration: BoxDecoration(
              color: Colors.purple, borderRadius: BorderRadius.circular(10)),
        ),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.purple,
        ),
        body: Container(
          color: mainList.isEmpty ? Colors.white : Colors.grey[100],
          child: ListView(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50))),
                height: 140,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 5),
                  child: RichText(
                    text: TextSpan(
                        children: [
                          TextSpan(
                              text: "Ordered!",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold))
                        ],
                        text: "Make Your Day ",
                        style: TextStyle(color: Colors.white, fontSize: 40)),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              mainList.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        height: 180.0 * mainList.length,
                        child: ListView.builder(
                          itemCount: mainList.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return MainLists(
                              title: mainList[index]["title"],
                              des: mainList[index]['des'],
                              list: mainList[index]['lists'],
                              index: index,
                              imp: mainList[index]['important'],
                            );
                          },
                        ),
                      ),
                    )
                  : Center(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/nodata.png",
                          width: 300,
                        ),
                        Text("No Todo Lists Created!",
                            style: TextStyle(
                              fontSize: 20,
                            ))
                      ],
                    ))
            ],
          ),
        ),
      ),
    );
  }

  void getList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String lists = pref.getString("mainList");
    mainList = json.decode(lists);
    print(lists);
    setState(() {});
  }
}

class MainLists extends StatefulWidget {
  final title;
  final des;
  final List list;
  final index;
  final imp;

  MainLists({this.title, this.des, this.list, this.index, this.imp});
  @override
  _MainListsState createState() => _MainListsState();
}

class _MainListsState extends State<MainLists> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ListsPage(
                    appbar: widget.title,
                    index: widget.index,
                  )));
        },
        child: Container(
          padding: EdgeInsets.only(top: 35, left: 35, right: 35, bottom: 5),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    widget.imp == "true"
                        ? Icon(
                            Icons.flag,
                            color: Colors.orangeAccent,
                          )
                        : Container()
                  ],
                ),
                Text(
                  widget.des,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black38,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.red[700],
                      child: IconButton(
                        onPressed: () async {
                          mainList.removeAt(widget.index);
                          SharedPreferences pref =
                              await SharedPreferences.getInstance();
                          pref.setString("mainList", json.encode(mainList));
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => Home()));
                          setState(() {});
                        },
                        icon: Icon(
                          Icons.delete,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 15,
                  color: Colors.black45,
                  spreadRadius: 1,
                ),
              ]),
        ),
      ),
    );
  }
}
