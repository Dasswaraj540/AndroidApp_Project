import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';

formatTime(Timestamp date) {
  // DateTime dateTime = DateTime.parse(time);
  DateTime dateTime = date.toDate();
  String formattedTime = DateFormat('h:mm a').format(dateTime);
  return formattedTime;
}

formatDate(Timestamp date) {
  // DateTime dateTime = DateTime.parse(date);
  DateTime dateTime = date.toDate();
  String formattedDate = DateFormat('d MMMM yyyy').format(dateTime);
  return formattedDate;
}
