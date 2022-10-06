import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../models/item.dart';
import './addpage.dart';
import './editpage.dart';
import 'package:flutter/material.dart';
import './search.dart';
import '../services/firebase_crud.dart';

class ListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ListPage();
  }
}

class _ListPage extends State<ListPage> {
  final Stream<QuerySnapshot> collectionReference = FirebaseCrud.readEmployee();
  //FirebaseFirestore.instance.collection('Employee').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Center(child: const Text("Pharmacy Management",)),
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          /*IconButton(
            icon: Icon(
              Icons.add_circle_sharp,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => AddPage(),
                ),
                    (route) =>
                false, //if you want to disable back feature set to false
              );
            },
          ),*/
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => SearchPage(),
                ),
                    (route) =>
                true, //if you want to disable back feature set to false
              );
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: collectionReference,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ListView(
                children: snapshot.data!.docs.map((e) {
                  return Card(
                      elevation: 5,
                      margin: EdgeInsets.symmetric(
                      vertical: 19,
                      horizontal: 5,),
                      child: Row(
                        children: [
                          Container(
                            height: 60,
                            width: 100,
                            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15,),
                            decoration: BoxDecoration(border: Border.all(
                              color: Theme.of(context).primaryColor,
                              width: 2,)),
                            padding: EdgeInsets.all(10),
                            child: FittedBox(
                              child: Text(e["employee_name"],
                                style: TextStyle(
                                    color: Theme.of(context).primaryColorDark),),
                            ),
                          ),
                          Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FittedBox(
                                child: Text("Group:  " + e['position'],),
                              ),
                              SizedBox(height: 10,),

                              Text("Company:" + e['contact_no']),
                            ],
                          ),),
                          IconButton(
                            icon: Icon(Icons.edit),
                            color: Colors.black,
                            onPressed: () {
                              Navigator.pushAndRemoveUntil<dynamic>(
                                context,
                                MaterialPageRoute<dynamic>(
                                  builder: (BuildContext context) => EditPage(
                                    employee: Employee(
                                        uid: e.id,
                                        employeename: e["employee_name"],
                                        position: e["position"],
                                        contactno: e["contact_no"]),
                                  ),
                                ),
                                    (route) =>
                                false, //if you want to disable back feature set to false
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.grey,
                            onPressed: () async {
                              var response =
                              await FirebaseCrud.deleteEmployee(docId: e.id);
                              if (response.code != 200) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content:
                                        Text(response.message.toString()),
                                      );
                                    });
                              }
                            },
                          ),
                        ],
                      ));
                }).toList(),
              ),
            );
          }

          return Container();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: ()=>{
      Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
      builder: (BuildContext context) => AddPage(),
      ),
      (route) =>
      false, //if you want to disable back feature set to false
      )
      },

      ),
    );
  }
}