import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class crudmonHoc extends StatefulWidget {
  static const routeName = '/crudmonHoc';
  @override
  State<crudmonHoc> createState() => _crudmonHocState();
}

class _crudmonHocState extends State<crudmonHoc> {
  // text fields' controllers
  @override
  final TextEditingController _maMHController = TextEditingController();
  final TextEditingController _tenMHController = TextEditingController();
  final TextEditingController _moTaController = TextEditingController();

  final CollectionReference _subjects =
      FirebaseFirestore.instance.collection('subjects');

  // This function is triggered when the floatting button or one of the edit buttons is pressed
  // Adding a product if no documentSnapshot is passed
  // If documentSnapshot != null then update an existing product
  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _maMHController.text = documentSnapshot['maMH'];
      _tenMHController.text = documentSnapshot['tenMH'];
      _moTaController.text = documentSnapshot['moTa'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                // prevent the soft keyboard from covering text fields
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _maMHController,
                  decoration: const InputDecoration(labelText: 'Mã Môn Học'),
                ),
                TextField(
                  controller: _tenMHController,
                  decoration: const InputDecoration(labelText: 'Tên Môn Học'),
                ),
                TextField(
                  controller: _moTaController,
                  decoration: const InputDecoration(labelText: 'Mô Tả'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text(action == 'create' ? 'Create' : 'Update'),
                  onPressed: () async {
                    final String? maMH = _maMHController.text;
                    final String? tenMH = _tenMHController.text;
                    final String? moTa = _moTaController.text;
                    if (maMH != null && tenMH != null && moTa != null) {
                      if (action == 'create') {
                        // Persist a new product to Firestore
                        await _subjects.add({
                          "maMH": maMH,
                          "tenMH": tenMH,
                          "moTa": moTa,
                        });
                      }

                      if (action == 'update') {
                        // Update the product
                        await _subjects.doc(documentSnapshot!.id).update({
                          "maMH": maMH,
                          "tenMH": tenMH,
                          "moTa": moTa,
                        });
                      }

                      // Clear the text fields
                      _maMHController.text = '';
                      _tenMHController.text = '';
                      _moTaController.text = '';

                      // Hide the bottom sheet
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  // Deleteing a product by id
  Future<void> _deleteNews(String subjectId) async {
    await _subjects.doc(subjectId).delete();

    // Show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a subject')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 90, 142, 201),
        title: const Text('CRUD MÔN HỌC'),
      ),
      // Using StreamBuilder to display all products from Firestore in real-time
      body: StreamBuilder(
        stream: _subjects.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(documentSnapshot['maMH']),
                    subtitle: Text(documentSnapshot['tenMH']),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          // Text(documentSnapshot['moTa']),
                          // Press this button to edit a single product
                          IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () =>
                                  _createOrUpdate(documentSnapshot)),
                          // This icon button is used to delete a single product
                          IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () =>
                                  _deleteNews(documentSnapshot.id)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      // Add new product
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createOrUpdate(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
