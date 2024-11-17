// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';

// Future<void> createEvent(
//     String name,
//     String desc,
//     String location,
//     DateTime date,
//     String guest,
//     String branch,
//     String year,
//     FilePickerResult? filePickerResult) async {
//   String imgURL = '';
//   String uniqueFileName = DateTime.now().microsecondsSinceEpoch.toString();
//   Reference refRoot = FirebaseStorage.instance.ref();
//   Reference refDirImages = refRoot.child('images');
//   Reference refImageUpload = refDirImages.child(uniqueFileName);
//   try {
//     await refImageUpload.putFile(File(filePickerResult!.files.first.path!));

//     imgURL = await refImageUpload.getDownloadURL();
//   } catch (e) {
//     print(e);
//   }

//   CollectionReference collRef = FirebaseFirestore.instance.collection('events');
//   collRef
//       .add({
//         'name': name,
//         'description': desc,
//         'location': location,
//         'dateTime': Timestamp.fromDate(date),
//         'guest': guest,
//         'branch': branch,
//         'year': year,
//         'image': imgURL,
//         'participants': []
//       })
//       .then((value) => print('Event Created'))
//       .catchError((onError) => print(onError));
// }

// Future getAllEvents() async {
//   CollectionReference _collectionRef =
//       FirebaseFirestore.instance.collection('events');
//   try {
//     QuerySnapshot querySnapshot = await _collectionRef
//         .where('dateTime', isGreaterThan: Timestamp.now())
//         .orderBy('dateTime')
//         .get();

//     // Get data from docs and convert map to List
//     final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
//     // print(allData[0]);
//     // print(allData[0][])
//     return allData;

//     // print(allData);
//   } catch (e) {
//     print(e);
//   }
// }

// Future<void> createProfile(String name, String age, String phone, String regdNo,
//     FilePickerResult? filePickerResult) async {
//   String imgURL = '';
//   String uniqueFileName = DateTime.now().microsecondsSinceEpoch.toString();
//   Reference refRoot = FirebaseStorage.instance.ref();
//   Reference refDirImages = refRoot.child('images');
//   Reference refImageUpload = refDirImages.child(uniqueFileName);
//   try {
//     await refImageUpload.putFile(File(filePickerResult!.files.first.path!));

//     imgURL = await refImageUpload.getDownloadURL();
//   } catch (e) {
//     print(e);
//   }
//   final FirebaseAuth auth = FirebaseAuth.instance;
//   final User? user = auth.currentUser;
//   final uid = user!.uid;
//   final String? email = user!.email;

//   CollectionReference collRef =
//       FirebaseFirestore.instance.collection('profile');
//   collRef
//       .doc(uid)
//       .set({
//         'name': name,
//         'age': age,
//         'phone': phone,
//         'regdNo': regdNo,
//         'image': imgURL,
//         'uid': uid,
//         'email': email
//       })
//       .then((value) => print('Profile Created'))
//       .catchError((onError) => print(onError));
// }

// Future getProfile() async {
//   final FirebaseAuth auth = FirebaseAuth.instance;
//   final User? user = auth.currentUser;
//   final uid = user!.uid;
//   CollectionReference _collectionRef =
//       FirebaseFirestore.instance.collection('profile');
//   try {
//     QuerySnapshot querySnapshot =
//         await _collectionRef.where('uid', isEqualTo: uid).get();

//     // Get data from docs and convert map to List
//     final allData = await querySnapshot.docs.map((doc) => doc.data()).toList();
//     // print(allData[0]);
//     // print(allData[0][])
//     // print(allData);
//     return allData;

//     // print(allData);
//   } catch (e) {
//     print(e);
//   }
// }

// Future updateUserProfile(String name, String phone, String email,
//     String password, FilePickerResult? filePickerResult, String oldURL) async {
//   if (filePickerResult != null) {
//     String imgURL = '';
//     String uniqueFileName = DateTime.now().microsecondsSinceEpoch.toString();
//     Reference refRoot = FirebaseStorage.instance.ref();
//     Reference refDirImages = refRoot.child('images');
//     Reference refImageUpload = refDirImages.child(uniqueFileName);
//     try {
//       await refImageUpload.putFile(File(filePickerResult!.files.first.path!));

//       imgURL = await refImageUpload.getDownloadURL();
//     } catch (e) {
//       print(e);
//     }

//     final FirebaseAuth auth = FirebaseAuth.instance;
//     final User? user = auth.currentUser;

//     final uid = user!.uid;

//     CollectionReference collRef =
//         FirebaseFirestore.instance.collection('profile');
//     collRef.doc(uid).update({'name': name, 'phone': phone, 'image': imgURL});

//     FirebaseStorage.instance.refFromURL(oldURL).delete();
//   }

//   final FirebaseAuth auth = FirebaseAuth.instance;
//   final User? user = auth.currentUser;
//   final uid = user!.uid;
//   CollectionReference collRef =
//       FirebaseFirestore.instance.collection('profile');
//   collRef.doc(uid).update({'name': name, 'phone': phone});
// }

// Future<void> createPost(
//     String name, String msg, String profileImg, File? filePickerResult) async {
//   String imgURL = '';
//   String uniqueFileName = DateTime.now().microsecondsSinceEpoch.toString();
//   Reference refRoot = FirebaseStorage.instance.ref();
//   Reference refDirImages = refRoot.child('images');
//   Reference refImageUpload = refDirImages.child(uniqueFileName);
//   try {
//     await refImageUpload.putFile(filePickerResult!);

//     imgURL = await refImageUpload.getDownloadURL();
//   } catch (e) {
//     print(e);
//   }

//   CollectionReference collRef =
//       FirebaseFirestore.instance.collection('UsersData');
//   collRef
//       .add({
//         'name': name,
//         'Message': msg,
//         'profileImg': profileImg,
//         'image': imgURL,
//         "TimeStamp": Timestamp.now(),
//         'Likes': []
//       })
//       .then((value) => print('Post Created'))
//       .catchError((onError) => print(onError));
// }

// Future RSVP(List participants, String docID, bool flag) async {
//   final FirebaseAuth auth = FirebaseAuth.instance;
//   final User? user = auth.currentUser;
//   final uid = user!.uid;

//   try {
//     if (!flag) {
//       await FirebaseFirestore.instance.collection('events').doc(docID).update({
//         'participants': FieldValue.arrayUnion([uid])
//       });
//       return true;
//     } else {
//       await FirebaseFirestore.instance.collection('events').doc(docID).update({
//         'participants': FieldValue.arrayRemove([uid])
//       });
//       return false;
//     }
//   } catch (e) {
//     print(e);
//   }
// }

// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

Future<void> createEvent(
    String name,
    String desc,
    String location,
    DateTime date,
    String guest,
    String branch,
    String year,
    FilePickerResult? filePickerResult) async {
  String imgURL = '';
  String uniqueFileName = DateTime.now().microsecondsSinceEpoch.toString();
  Reference refRoot = FirebaseStorage.instance.ref();
  Reference refDirImages = refRoot.child('images');
  Reference refImageUpload = refDirImages.child(uniqueFileName);
  try {
    await refImageUpload.putFile(File(filePickerResult!.files.first.path!));

    imgURL = await refImageUpload.getDownloadURL();
  } catch (e) {
    print(e);
  }

  CollectionReference collRef = FirebaseFirestore.instance.collection('events');
  collRef.add({
    'name': name,
    'description': desc,
    'location': location,
    'dateTime': Timestamp.fromDate(date),
    'guest': guest,
    'branch': branch,
    'year': year,
    'image': imgURL,
    'participants': []
  }).then((value) {
    print(value.id);
    CollectionReference collRef =
        FirebaseFirestore.instance.collection('events');
    collRef.doc(value.id).update({
      'id': value.id,
    });

    print('Event Created');
  }).catchError((onError) {
    print(onError);
  });
}

Future RSVP(List participants, String docID, bool flag) async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final uid = user!.uid;

  try {
    if (!flag) {
      await FirebaseFirestore.instance.collection('events').doc(docID).update({
        'participants': FieldValue.arrayUnion([uid])
      });
      return true;
    } else {
      await FirebaseFirestore.instance.collection('events').doc(docID).update({
        'participants': FieldValue.arrayRemove([uid])
      });
      return false;
    }
  } catch (e) {
    print(e);
  }
}

Future getAllEvents() async {
  CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('events');
  try {
    QuerySnapshot querySnapshot = await _collectionRef
        .where('dateTime', isGreaterThan: Timestamp.now())
        .orderBy('dateTime')
        .get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    // print(allData[0]);
    // print(allData[0][])
    return allData;

    // print(allData);
  } catch (e) {
    print(e);
  }
}

Future<void> createProfile(String name, String age, String phone, String regdNo,
    FilePickerResult? filePickerResult) async {
  String imgURL = '';
  String uniqueFileName = DateTime.now().microsecondsSinceEpoch.toString();
  Reference refRoot = FirebaseStorage.instance.ref();
  Reference refDirImages = refRoot.child('images');
  Reference refImageUpload = refDirImages.child(uniqueFileName);
  try {
    await refImageUpload.putFile(File(filePickerResult!.files.first.path!));

    imgURL = await refImageUpload.getDownloadURL();
  } catch (e) {
    print(e);
  }
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final uid = user!.uid;
  final String? email = user!.email;

  CollectionReference collRef =
      FirebaseFirestore.instance.collection('profile');
  collRef
      .doc(uid)
      .set({
        'name': name,
        'age': age,
        'phone': phone,
        'regdNo': regdNo,
        'image': imgURL,
        'uid': uid,
        'email': email
      })
      .then((value) => print('Profile Created'))
      .catchError((onError) => print(onError));
}

Future getProfile() async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final uid = user!.uid;
  CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('profile');
  try {
    QuerySnapshot querySnapshot =
        await _collectionRef.where('uid', isEqualTo: uid).get();

    // Get data from docs and convert map to List
    final allData = await querySnapshot.docs.map((doc) => doc.data()).toList();
    // print(allData[0]);
    // print(allData[0][])
    // print(allData);
    return allData;

    // print(allData);
  } catch (e) {
    print(e);
  }
}

Future updateUserProfile(String name, String phone, String email,
    String password, FilePickerResult? filePickerResult, String oldURL) async {
  if (filePickerResult != null) {
    String imgURL = '';
    String uniqueFileName = DateTime.now().microsecondsSinceEpoch.toString();
    Reference refRoot = FirebaseStorage.instance.ref();
    Reference refDirImages = refRoot.child('images');
    Reference refImageUpload = refDirImages.child(uniqueFileName);
    try {
      await refImageUpload.putFile(File(filePickerResult!.files.first.path!));

      imgURL = await refImageUpload.getDownloadURL();
    } catch (e) {
      print(e);
    }

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    final uid = user!.uid;

    CollectionReference collRef =
        FirebaseFirestore.instance.collection('profile');
    collRef.doc(uid).update({'name': name, 'phone': phone, 'image': imgURL});

    FirebaseStorage.instance.refFromURL(oldURL).delete();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final uid = user!.uid;
  CollectionReference collRef =
      FirebaseFirestore.instance.collection('profile');
  collRef.doc(uid).update({'name': name, 'phone': phone});
}

Future<void> createPost(
    String name, String msg, String profileImg, File? filePickerResult) async {
  String imgURL = '';
  String uniqueFileName = DateTime.now().microsecondsSinceEpoch.toString();
  Reference refRoot = FirebaseStorage.instance.ref();
  Reference refDirImages = refRoot.child('images');
  Reference refImageUpload = refDirImages.child(uniqueFileName);
  try {
    await refImageUpload.putFile(filePickerResult!);

    imgURL = await refImageUpload.getDownloadURL();
  } catch (e) {
    print(e);
  }

  CollectionReference collRef =
      FirebaseFirestore.instance.collection('UsersData');
  collRef
      .add({
        'name': name,
        'Message': msg,
        'profileImg': profileImg,
        'image': imgURL,
        'Likes': [],
        'TimeStamp': Timestamp.now()
      })
      .then((value) => print('Post Created'))
      .catchError((onError) => print(onError));
}

Future<void> createReport(
  String name,
) async {
  CollectionReference collRef = FirebaseFirestore.instance.collection('report');
  collRef
      .doc()
      .set({
        'description': name,
      })
      .then((value) => print('Report Posted'))
      .catchError((onError) => print(onError));
}
