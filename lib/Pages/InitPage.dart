/// loading page after successful login
/// init all nessassry data
///
///
import 'package:cake_mania/Models/UserDataModel.dart';
import 'package:cake_mania/Notifiers/SectionNotifier.dart';
import 'package:cake_mania/Pages/HomePage.dart';
import 'package:cake_mania/services/AuthenticationService.dart';
import 'package:cake_mania/services/FirestoreDatabase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InitPage extends StatefulWidget {
  @override
  _InitPageState createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final _auth = Provider.of<Database>(context);
    _auth.initData(context);
  }

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<Database>(context);
    final uid = Provider.of<LocalUser>(context).uid;
    return FutureBuilder<DocumentSnapshot<Object?>>(
        future: _auth.getUserDataAsFuture(uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.connectionState == ConnectionState.done) {
              final userData =
                  UserData.from(snapshot.data!.data() as Map<String, dynamic>);
              return Provider<UserData>(
                  create: (_) => UserData(
                        confirmOrders: userData.confirmOrders,
                        favourites: userData.favourites,
                        previousOrderss: userData.previousOrderss,
                      ),
                  child: HomePage());
            } else {
              return Center();
            }
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            return Center();
          }
        });
  }
}
