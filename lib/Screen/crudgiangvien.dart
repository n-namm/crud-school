import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class crudGiangVien extends StatefulWidget {
  static const routeName = '/crudGiangVien';
  @override
  State<crudGiangVien> createState() => _crudGiangVienState();
}

class _crudGiangVienState extends State<crudGiangVien> {
  // text fields' controllers
  final TextEditingController _maGiangVienController = TextEditingController();
  final TextEditingController _hoTenController = TextEditingController();
  final TextEditingController _diaChiontroller = TextEditingController();
  final TextEditingController _soDienThoaiController = TextEditingController();

  final CollectionReference _teacher =
      FirebaseFirestore.instance.collection('teacher');

  // This function is triggered when the floatting button or one of the edit buttons is pressed
  // Adding a product if no documentSnapshot is passed
  // If documentSnapshot != null then update an existing product
  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _maGiangVienController.text = documentSnapshot['maGiangVien'];
      _hoTenController.text = documentSnapshot['hoTen'];
      _diaChiontroller.text = documentSnapshot['diaChi'];
      _soDienThoaiController.text = documentSnapshot['soDienThoai'];
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
                  controller: _maGiangVienController,
                  decoration: const InputDecoration(labelText: 'Mã Giang Vien'),
                ),
                TextField(
                  controller: _hoTenController,
                  decoration: const InputDecoration(labelText: 'Ho Ten'),
                ),
                TextField(
                  controller: _diaChiontroller,
                  decoration: const InputDecoration(labelText: 'Dia Chi'),
                ),
                TextField(
                  controller: _soDienThoaiController,
                  decoration: const InputDecoration(labelText: 'So Dien Thoai'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text(action == 'create' ? 'Create' : 'Update'),
                  onPressed: () async {
                    final String? maGiangVien = _maGiangVienController.text;
                    final String? hoTen = _hoTenController.text;
                    final String? diaChi = _diaChiontroller.text;
                    final String? soDienThoai = _soDienThoaiController.text;
                    if (maGiangVien != null && hoTen != null && diaChi != null && soDienThoai != null) {
                      if (action == 'create') {
                        // Persist a new product to Firestore
                        await _teacher.add({
                          "maGiangVien": maGiangVien,
                          "hoTen": hoTen,
                          "diaChi": diaChi,
                          "soDienThoai": soDienThoai,
                        });
                      }

                      if (action == 'update') {
                        // Update the product
                        await _teacher
                            .doc(documentSnapshot!.id)
                            .update({
                              "maGiangVien": maGiangVien,
                              "hoTen": hoTen,
                              "diaChi": diaChi,
                              "soDienThoai": soDienThoai,
                            });
                      }

                      // Clear the text fields
                      _maGiangVienController.text = '';
                      _hoTenController.text = '';
                      _diaChiontroller.text = '';
                      _soDienThoaiController.text = '';

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
    await _teacher.doc(productId).delete();

    // Show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a Teacher')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD Giang Vien'),
      ),
      // Using StreamBuilder to display all products from Firestore in real-time
      body: StreamBuilder(
        stream: _teacher.snapshots(),
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
                    title: Text(documentSnapshot['maGiangVien']),
                    subtitle: Text(documentSnapshot['hoTen']),
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