/// loading page after successful login
/// init all nessassry data
///
///
import 'package:cake_mania/Notifiers/SectionNotifier.dart';
import 'package:cake_mania/Pages/HomePage.dart';
import 'package:cake_mania/services/FirestoreDatabase.dart';
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
    return HomePage();
  }
}
