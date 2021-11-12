import 'package:cake_mania/Models/DeliveryDetailsModel.dart';
import 'package:cake_mania/Models/UserSettingsModel.dart';
import 'package:cake_mania/Notifiers/CakeOrderNotifier.dart';
import 'package:cake_mania/Notifiers/DeliveryModelNotifier.dart';
import 'package:cake_mania/Notifiers/SectionNotifier.dart';
import 'package:cake_mania/Pages/HomePage.dart';
import 'package:cake_mania/services/AuthenticationService.dart';
import 'package:cake_mania/services/user_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:provider/provider.dart';

abstract class Database {
  void initData(BuildContext context);
  Stream<DocumentSnapshot<Object?>> getUserDataAsStream(String userId);
  Future<DocumentSnapshot<Object?>> getUserDataAsFuture(String userId);
  // Future<DocumentSnapshot<Object?>> getCakeIdAsFuture(String cakeId);
  Future<void> createNewUser(LocalUser user);
  Future<void> updateUser(String userId, Map<String, dynamic> json);
  Future<void> updateUserDeliveryDetails(
      String userId, Map<String, dynamic> json);
  Future<void> deleteUser(String userId);
  Future<void> addToFavourite(String userId, int value);
  Future<void> removeFromFavourite(String userId, int value);
  Future<void> confirmOrder(
      {required LocalUser user,
      required Map<String, dynamic> order,
      required String orderId,
      required Map<String, dynamic> deliveryDetails});
  Stream<DocumentSnapshot<Object?>> getMyConfirmedOrders(String uid);
  Stream<DocumentSnapshot<Object?>> getMyCompletedOrders(String uid);
  // Stream<DocumentSnapshot<Object?>> getPaymentStaus(String uid);
  void getPaymentStaus(String uid, BuildContext context);
  Future<DocumentSnapshot<Object?>> getAllCakes();
  Future<DocumentSnapshot<Object?>> getSectionData(String sectionName);

  // Future<SectionModel?> getSection(String sectionName);
}

class MyFirestoreDatabse implements Database {
  CollectionReference _adminReference =
      FirebaseFirestore.instance.collection('admin');
  CollectionReference _orderTrack =
      FirebaseFirestore.instance.collection('orderTrack');
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

  void initData(BuildContext context) async {
    final user = Provider.of<LocalUser>(context);
    final cakeOrderNotifier = Provider.of<CakeOrderNotifier>(context);
    final _deliveryDetails = context.read<DeliveryModelNotifier>();
    final _section = context.read<SectionNameNotifier>();
    cakeOrderNotifier.setCakeOrderModel = UserPreference.getOrderDetails();
    final _sectionReferenceDoc = _sectionReference.get().asStream();
    _sectionReferenceDoc.forEach((element) {
      element.docs.forEach((x) {
        _section.addSectionNames(x.id);
      });
    });
    final _userReferenceDoc = _userReference
        .doc(user.uid)
        .collection('UserData')
        .doc('data')
        .get()
        .asStream();
    _userReferenceDoc.forEach((element) {
      if (element.data() != null) {
        // print(element.data());
        final json = element.data() as Map<String, dynamic>;
        final data =
            DeliveryDetailsModel.fromJson(json["userData"]["deliveryDetails"]);
        _deliveryDetails.changeDeliveryDetails(data);
      } else {
        print('User have not updated address');
      }
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

  Stream<DocumentSnapshot<Object?>> getMyCompletedOrders(String uid) {
    final _doc = _userReference
        .doc(uid)
        .collection("previousOrders")
        .doc("orders")
        .snapshots();
    return _doc;
  }

  // Stream<DocumentSnapshot<Object?>> getPaymentStaus(String uid) {
  void getPaymentStaus(String uid, BuildContext context) {
    context.dependOnInheritedWidgetOfExactType();
    final userSettings = UserPreference.getUserSettings();
    final _doc = _userReference
        .doc(uid)
        .collection("confirmOrders")
        .doc("orders")
        .snapshots();
    _doc.forEach((element) {
      {
        bool isPaid = false;
        element.data()!.forEach((key, value) {
          if (value['paymentStatus'] == 'paid' &&
              value['orderId'] == userSettings.orderId &&
              userSettings.notifyPaidOrder == true) {
            isPaid = true;
          }
        });
        if (isPaid) {
          Dialogs.materialDialog(
              color: Colors.white,
              msg: 'Payment has been Completed',
              title: 'Congratulations',
              // animation: 'assets/cong_example.json',
              context: context,
              actions: [
                IconsButton(
                  onPressed: () {
                    UserPreference.saveUserSettings(OrderRelatedSettings(
                        notifyPaidOrder: false, orderId: ''));
                    // Navigator.pop(context);
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  text: 'Thanks',
                  iconData: Icons.done,
                  color: Colors.blue,
                  textStyle: TextStyle(color: Colors.white),
                  iconColor: Colors.white,
                ),
              ]);
        }
      }
    });
  }

  Future<void> confirmOrder(
      {required LocalUser user,
      required Map<String, dynamic> order,
      required String orderId,
      required Map<String, dynamic> deliveryDetails}) async {
    _orderTrack
        .doc("orders")
        .set(
          {
            user.uid: {
              'name': user.displayName,
              'userId': user.uid,
            }
          },
          SetOptions(merge: true),
        )
        .then((json) => print("User Added to Orders list"))
        .catchError(
            (error) => print("Failed to Add User to Orders list: $error"));

    _adminReference
        .doc("OrdersBy")
        .update(
          {
            "activeOrders": FieldValue.arrayUnion([LocalUser.toJson(user)]),
          },
        )
        .then((json) => print("User Added to Orders list"))
        .catchError(
            (error) => print("Failed to Add User to Orders list: $error"));

    _userReference
        .doc(user.uid)
        .collection("confirmOrders")
        .doc("orders")
        .set(
          {orderId: order},
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

  Future<void> createNewUser(LocalUser user) async {
    _userReference.doc(user.uid).collection("UserData").doc("data").set({});
    _userReference
        .doc(user.uid)
        .collection("previousOrders")
        .doc("orders")
        .set({});
    _userReference
        .doc(user.uid)
        .collection("confirmOrders")
        .doc("orders")
        .set({})
        .then((value) => print("User\'s Account Created"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> updateUser(String userId, Map<String, dynamic> json) async {
    /// key must be accurate ex. {UserData.searchedKeywords:'keyword'}
    /// key = UserData.searchedKeywords, value = 'keyword'
    _userReference
        .doc(userId)
        .collection("UserData")
        .doc("data")
        .update(
          {
            "userData.profile": json,
          },
        )
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateUserDeliveryDetails(
      String userId, Map<String, dynamic> json) async {
    /// key must be accurate ex. {UserData.searchedKeywords:'keyword'}
    /// key = UserData.searchedKeywords, value = 'keyword'
    _userReference
        .doc(userId)
        .collection("UserData")
        .doc("data")
        .set(
          {
            "userData": {
              "deliveryDetails": json,
            }
          },
        )
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
