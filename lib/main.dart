import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

void main() {
  runApp(const FirebaseRealtimeDemoScreen());
}

class FirebaseRealtimeDemoScreen extends StatefulWidget {
  const FirebaseRealtimeDemoScreen({Key? key}) : super(key: key);

  @override
  State<FirebaseRealtimeDemoScreen> createState() =>
      _FirebaseRealtimeDemoScreenState();
}

class _FirebaseRealtimeDemoScreenState
    extends State<FirebaseRealtimeDemoScreen> {
  final databaseReference = FirebaseDatabase.instance.ref();
  late String text = "flowers";

  @override
  Widget build(BuildContext context) {
    readData();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Realtime Database Demo'),
        ),
        body: Center(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ElevatedButton(
                child: const Text('Create Data'),
                onPressed: () {
                  createData();
                },
              ),
              const SizedBox(
                height: 8,
              ),
              ElevatedButton(
                child: const Text('Read/View Data'),
                onPressed: () {
                  readData();
                },
              ),
              const SizedBox(
                height: 8,
              ),
              ElevatedButton(
                child: const Text('Update Data'),
                onPressed: () {
                  updateData();
                },
              ),
              const SizedBox(
                height: 8,
              ),
              ElevatedButton(
                child: const Text('Delete Data'),
                onPressed: () {
                  deleteData();
                },
              ),
              FloatingActionButton(
                shape: const BeveledRectangleBorder(
                    borderRadius: BorderRadius.zero),
                onPressed: controlData,
                child: const Text("Control data"),
              ),
              SizedBox(
                height: 50,
                width: 50,
                child: _buildChild(),
              )
            ],
          ),
        )), //center
      ),
    );
  }

  void createData() {
    databaseReference
        .child("plants")
        .child("flowers")
        .child("roses")
        .child("whiteRose")
        .set({'type': 'rose', 'description': 'A white rose.', 'price': '80'});
  }

  void readData() {
    databaseReference
        .child("plants")
        .child("flowers")
        .child("roses")
        .child("whiteRose")
        .child('type')
        .once()
        .then((event) {
      DataSnapshot snapshot = event.snapshot;
      if (kDebugMode) {
        print('Data : ${snapshot.value}');
      }
    });
  }

  void updateData() {
    databaseReference
        .child('plants')
        .child("flowers")
        .child("roses")
        .child("whiteRose")
        .update({'description': 'Just a white rose.'});
  }

  void deleteData() {
    databaseReference.child('plants').child("flowers").remove();
  }

  void controlData() {
    FirebaseDatabase.instance
        .ref()
        .child("plants")
        .child(text)
        .once()
        .then((event) {
      DataSnapshot snapshot = event.snapshot;
      bool a = snapshot.exists;
      if (a == true) {
        if (kDebugMode) {
          print("doğru");
        }
      } else if (a == false) {
        if (kDebugMode) {
          print("oooppss yanlış");
        }
      } else {
        if (kDebugMode) {
          print("işlem tamamlanmadı");
        }
      }

    });
  }

  Widget _buildChild() {
    return Column(
      children: <Widget>[
        StreamBuilder<DatabaseEvent>(
          stream: FirebaseDatabase.instance
              .ref()
              .child("plants")
              .child("flowers")
              .child("roses")
              .child("whiteRose")
              .onValue,
          builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> event) {
            Map<dynamic, dynamic> data = event.data!.snapshot.value as Map;
            return Column(children: [
              Text('Description :${data['description']}',
                  style: const TextStyle(fontSize: 30.0)),
            ]);
          },
        ),
      ],
    );
  }
}
