import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class crudSinhVien extends StatefulWidget {
  static const routeName = '/crudSinhVien';
  @override
  State<crudSinhVien> createState() => _crudSinhVienState();
}

class _crudSinhVienState extends State<crudSinhVien> {
  // text fields' controllers
  final TextEditingController _maSinhVienController = TextEditingController();
  final TextEditingController _ngaySinhController = TextEditingController();
  final TextEditingController _gioiTinhController = TextEditingController();
  final TextEditingController _queQuanController = TextEditingController();

  final CollectionReference _student =
      FirebaseFirestore.instance.collection('STUDEN');

  // This function is triggered when the floatting button or one of the edit buttons is pressed
  // Adding a product if no documentSnapshot is passed
  // If documentSnapshot != null then update an existing product
  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _maSinhVienController.text = documentSnapshot['maSinhVien'];
      _ngaySinhController.text = documentSnapshot['ngaySinh'];
      _gioiTinhController.text = documentSnapshot['gioiTinh'];
      _queQuanController.text = documentSnapshot['queQuan'];
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
                  controller: _maSinhVienController,
                  decoration: const InputDecoration(labelText: 'Mã Sinh Vien'),
                ),
                TextField(
                  controller: _ngaySinhController,
                  decoration: const InputDecoration(labelText: 'Ngay Sinh'),
                ),
                TextField(
                  controller: _gioiTinhController,
                  decoration: const InputDecoration(labelText: 'Gioi Tinh'),
                ),
                TextField(
                  controller: _queQuanController,
                  decoration: const InputDecoration(labelText: 'Que Quan'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text(action == 'create' ? 'Create' : 'Update'),
                  onPressed: () async {
                    final String? maSinhVien = _maSinhVienController.text;
                    final String? ngaySinh = _ngaySinhController.text;
                    final String? gioiTinh = _gioiTinhController.text;
                    final String? queQuan = _queQuanController.text;
                    if (maSinhVien != null && ngaySinh != null && gioiTinh != null && queQuan != null) {
                      if (action == 'create') {
                        // Persist a new product to Firestore
                        await _student.add({
                          "maSinhVien": maSinhVien,
                          "ngaySinh": ngaySinh,
                          "gioiTinh": gioiTinh,
                          "queQuan": queQuan,
                        });
                      }

                      if (action == 'update') {
                        // Update the product
                        await _student
                            .doc(documentSnapshot!.id)
                            .update({
                                "maSinhVien": maSinhVien,
                                "ngaySinh": ngaySinh,
                                "gioiTinh": gioiTinh,
                                "queQuan": queQuan,
                            });
                      }

                      // Clear the text fields
                      _maSinhVienController.text = '';
                      _ngaySinhController.text = '';
                      _gioiTinhController.text = '';
                      _queQuanController.text = '';

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
  Future<void> _deleteProduct(String productId) async {
    await _student.doc(productId).delete();

    // Show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a Student')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD Sinh Vien'),
      ),
      // Using StreamBuilder to display all products from Firestore in real-time
      body: StreamBuilder(
        stream: _student.snapshots(),
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
                    title: Text(documentSnapshot['maSinhVien']),
                    subtitle: Text(documentSnapshot['ngaySinh']),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          // Press this button to edit a single product
                          IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () =>
                                  _createOrUpdate(documentSnapshot)),
                          // This icon button is used to delete a single product
                          IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () =>
                                  _deleteProduct(documentSnapshot.id)),
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