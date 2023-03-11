import 'package:crud/Screen/crudgiangvien.dart';
import 'package:crud/Screen/crudmonhoc.dart';
import 'package:crud/Screen/crudsinhvien.dart';
import 'package:flutter/material.dart';

import 'crudlophoc.dart';

class CardApp extends StatelessWidget {
  static String routeName = "/card";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorSchemeSeed: const Color(0xff6750a4), useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(title: const Text('CRUD')),
        body: Column(
          children: const <Widget>[
            Spacer(),
            OutlinedStudens(),
            OutlinedGiangVien(),
            Outlinedlophoc(),
            Outlinedmonhoc(),
            Spacer(),
          ],
        ),
      ),
    );
  }
}

class Outlinedlophoc extends StatelessWidget {
  const Outlinedlophoc({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: SizedBox(
          width: 300,
          height: 100,
          child: Center(
            child: TextButton(
              child: Text('CRUD Lớp Học'),
              onPressed: () {
                final route =
                    MaterialPageRoute(builder: (context) => crudlophoc());
                Navigator.push(context, route);
              },
            ),
          ),
        ),
      ),
    );
  }
}

class OutlinedStudens extends StatelessWidget {
  const OutlinedStudens({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: SizedBox(
          width: 300,
          height: 100,
          child: Center(
            child: TextButton(
              child: Text('CRUD Sinh Viên'),
              onPressed: () {
                final route =
                    MaterialPageRoute(builder: (context) => crudSinhVien());
                Navigator.push(context, route);
              },
            ),
          ),
        ),
      ),
    );
  }
}

class OutlinedGiangVien extends StatelessWidget {
  const OutlinedGiangVien({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: SizedBox(
          width: 300,
          height: 100,
          child: Center(
            child: TextButton(
              child: Text('CRUD Giảng Viên'),
              onPressed: () {
                final route =
                    MaterialPageRoute(builder: (context) => crudGiangVien());
                Navigator.push(context, route);
              },
            ),
          ),
        ),
      ),
    );
  }
}

class Outlinedmonhoc extends StatelessWidget {
  const Outlinedmonhoc({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: SizedBox(
          width: 300,
          height: 100,
          child: Center(
            child: TextButton(
              child: Text('CRUD Môn Học'),
              onPressed: () {
                final route =
                    MaterialPageRoute(builder: (context) => crudmonHoc());
                Navigator.push(context, route);
              },
            ),
          ),
        ),
      ),
    );
  }
}

