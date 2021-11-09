import 'package:cake_mania/Models/CakeDetailsNotifier.dart';
import 'package:cake_mania/Models/UserSettingsModel.dart';
import 'package:cake_mania/MyApp.dart';
import 'package:cake_mania/Notifiers/CakeOrderNotifier.dart';
import 'package:cake_mania/Notifiers/DeliveryModelNotifier.dart';
import 'package:cake_mania/Notifiers/SectionNotifier.dart';
import 'package:cake_mania/services/AuthenticationService.dart';
import 'package:cake_mania/services/FirestoreDatabase.dart';
import 'package:cake_mania/services/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await UserPreference.init();
  // await NotificationService.init();
  UserSettingsModel.init();

  runApp(RootApp());
}

class RootApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CakeOrderNotifier()),
        ChangeNotifierProvider(create: (_) => CakeDetailsNotifier()),
        ChangeNotifierProvider(create: (_) => SectionNameNotifier()),
        ChangeNotifierProvider(create: (_) => DeliveryModelNotifier()),
        Provider<AuthBase>(create: (context) => Auth()),
        Provider<Database>(create: (context) => MyFirestoreDatabse()),
      ],
      child: MyApp(),
    );
  }
}
