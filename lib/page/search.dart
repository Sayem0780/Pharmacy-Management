import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const FirebaseSearchScreen();
  }
}

class FirebaseSearchScreen extends StatefulWidget {
  const FirebaseSearchScreen({Key? key}) : super(key: key);

  @override
  State<FirebaseSearchScreen> createState() => _FirebaseSearchScreenState();
}

class _FirebaseSearchScreenState extends State<FirebaseSearchScreen> {
  List searchResult = [];

  void searchFromFirebase(String query) async {
    final result = await FirebaseFirestore.instance
        .collection('products')
        .where('employee_name', isEqualTo: query)
        .get();

    setState(() {
      searchResult = result.docs.map((e) => e.data()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pharmacy Management"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Search Medicine Name",
              ),
              onChanged: (query) {
                searchFromFirebase(query);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchResult.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Row(
                    children: [
                      Container(
                        height: 60,
                        width: 100,
                        margin: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).primaryColorLight,

                          )
                        ),
                        padding: EdgeInsets.all(10),
                        child: FittedBox(
                          child: Text(searchResult[index]['employee_name'],
                            style: TextStyle(
                              color: Theme.of(context).primaryColorDark,
                            ) ,),
                        ),
                      ),
                      Expanded(child: Column(
                        //mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                            child: Text("Group:  " + searchResult[index]['position'],style:Theme.of(context).textTheme.headline6),
                          ),
                          SizedBox(height: 10,),
                          FittedBox(
                            child: Text("Company:" + searchResult[index]['contact_no'],style: Theme.of(context).textTheme.bodyText1,),
                          )
                        ],
                      ))
                    ],
                  ),
                );


                  /*ListTile(
                  title: Text(searchResult[index]['employee_name']),
                  subtitle: Text(searchResult[index]['position']),
                );*/
              },
            ),
          ),
        ],
      ),
    );
  }
}