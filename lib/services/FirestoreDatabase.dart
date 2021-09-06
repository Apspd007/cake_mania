import 'package:cake_mania/Models/SectionModel.dart';
import 'package:cake_mania/Notifiers/OrderBillNotifier.dart';
import 'package:cake_mania/Notifiers/SectionNotifier.dart';
import 'package:cake_mania/services/AuthenticationService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class Database {
  void initData(BuildContext context);
  Stream<DocumentSnapshot<Object?>> getUserDataAsStream(String userId);
  Future<DocumentSnapshot<Object?>> getUserDataAsFuture(String userId);
  // Future<DocumentSnapshot<Object?>> getCakeIdAsFuture(String cakeId);
  Future<void> createUser(LocalUser user, Map<String, dynamic> data);
  Future<void> updateUser(String userId, String key, dynamic value);
  Future<void> deleteUser(String userId);
  Future<void> addToFavourite(String userId, int value);
  Future<void> removeFromFavourite(String userId, int value);
  Future<void> confirmOrder(
      LocalUser user, Map<String, dynamic> value, String orderId);
  Stream<DocumentSnapshot<Object?>> getMyConfirmedOrders(String uid);
  Future<DocumentSnapshot<Object?>> getAllCakes();
  Future<DocumentSnapshot<Object?>> getSectionData(String sectionName);

  // Future<SectionModel?> getSection(String sectionName);
}

class MyFirestoreDatabse implements Database {
  CollectionReference _adminReference =
      FirebaseFirestore.instance.collection('admin');
  CollectionReference _userReference =
      FirebaseFirestore.instance.collection('users');
  CollectionReference _cakeColReference =
      FirebaseFirestore.instance.collection('cakes');
  CollectionReference _sectionReference =
      FirebaseFirestore.instance.collection('cakeSections');
  // CollectionReference _cakeIdReference =
  //     FirebaseFirestore.instance.collection('cakeId');

  Stream<DocumentSnapshot<Object?>> getUserDataAsStream(String userId) {
    // final _doc = _userReference.doc("fTVZ94nHyJzYIy8kRvkO").snapshots();
    final _doc = _userReference.doc(userId).snapshots();
    return _doc;
  }

  Future<DocumentSnapshot<Object?>> getUserDataAsFuture(String userId) {
    // final _doc = _userReference.doc("fTVZ94nHyJzYIy8kRvkO").snapshots();
    final _doc = _userReference.doc(userId).get();
    return _doc;
  }

  Future<DocumentSnapshot<Object?>> getAllCakes() async {
    final _doc = _cakeColReference.doc("cakeList").get();
    return _doc;
  }

  Future<DocumentSnapshot<Object?>> getSectionData(String sectionName) async {
    final _result = _sectionReference.doc(sectionName).get();
    return _result;
  }

  // Future<SectionModel?> getSection(String sectionName) {
  //   SectionModel? sectionModel;
  //   final _result = _sectionReference.doc(sectionName).get().asStream();
  //   final v = _result.forEach((element) {
  //     final json = element.data() as Map<String, dynamic>;
  //     // print(SectionModel.fromJson(json));
  //     sectionModel = SectionModel.fromJson(json);
  //     // print(sectionModel);
  //   }).then((value) => sectionModel);
  //   print(v);
  //   return v;
  // }

  void initData(BuildContext context) async {
    final _section = context.read<SectionNameNotifier>();
    final _doc = _sectionReference.get();
    final _ = _doc.asStream();
    _.forEach((element) {
      element.docs.forEach((x) {
        _section.addSectionNames(x.id);
      });
    });
  }

  Stream<DocumentSnapshot<Object?>> getMyConfirmedOrders(String uid) {
    final _doc = _userReference
        .doc(uid)
        .collection("confirmOrders")
        .doc("orders")
        .snapshots();
    return _doc;
  }

  Future<void> confirmOrder(
      LocalUser user, Map<String, dynamic> json, String orderId) async {
    _adminReference.doc("cakeOrders").update(
      {
        "OrdersBy": FieldValue.arrayUnion([LocalUser.toJson(user)]),
      },
    );
    _adminReference
        .doc("cakeOrders")
        .collection("users")
        .doc(user.uid)
        .set(
          {orderId: json},
          SetOptions(merge: true),
        )
        .then((json) => print("Order Confirmed for Admin"))
        .catchError(
            (error) => print("Failed to Confirm Order from Admin: $error"));
    _userReference
        .doc(user.uid)
        .collection("confirmOrders")
        .doc("orders")
        .set(
          {orderId: json},
          SetOptions(merge: true),
        )
        .then((json) => print("Order Confirmed for User"))
        .catchError(
            (error) => print("Failed to Confirm Order from User: $error"));
  }

  Future<void> addToFavourite(String userId, int value) async {
    _userReference
        .doc(userId)
        .update({
          'UserData.favourites': FieldValue.arrayUnion([value])
        })
        .then((value) => print("Favourite list Updated"))
        .catchError(
            (error) => print("Failed to update favourite list: $error"));
  }

  Future<void> removeFromFavourite(String userId, int value) async {
    _userReference
        .doc(userId)
        .update({
          'UserData.favourites': FieldValue.arrayRemove([value])
        })
        .then((value) => print("Favourite list Updated"))
        .catchError(
            (error) => print("Failed to update favourite list: $error"));
  }

  Future<void> createUser(LocalUser user, Map<String, dynamic> data) async {
    _userReference
        .doc(user.uid)
        .set(data)
        .then((value) => print("User\'s Account Created"))
        .catchError((error) => print("Failed to add user: $error"));
    _adminReference
        .doc("cakeOrders")
        .collection("users")
        .doc(user.uid)
        .set({
          "confirmOrders": [],
        })
        .then((value) => print("User added to Admin Database"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> updateUser(String userId, String key, dynamic value) async {
    /// key must be accurate ex. {UserData.searchedKeywords:'keyword'}
    /// key = UserData.searchedKeywords, value = 'keyword'
    _userReference
        .doc(userId)
        .update({key: value})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> deleteUser(String userId) async {
    _userReference
        .doc(userId)
        .delete()
        .then((value) => print("User deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }
}
