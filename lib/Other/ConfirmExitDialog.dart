import 'package:cake_mania/Materials.dart';
import 'package:cake_mania/services/user_preferences.dart';
import 'package:flutter/material.dart';

class ConfirmExit {
  static Future<bool> showComfirmExitDialog(BuildContext context) async {
    return (await showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  backgroundColor: Theme.of(context).canvasColor,
                  title: Text(
                    'Exit?',
                    style: lobster2TextStyle(fontSize: 28, color: Colors.white),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop<bool>(context, false);
                        },
                        child: Text(
                          'No',
                          style: lobster2TextStyle(color: Colors.white),
                        )),
                    TextButton(
                        onPressed: () async {
                          await UserPreference.saveOrderDetails(context).then(
                              (value) => Navigator.pop<bool>(context, true));
                        },
                        child:
                            Text('Yes', style: lobster2TextStyle(color: Colors.white))),
                  ],
                ))) ??
        false;
  }
}












                // TextButton(
                //     onPressed: () {
                //       Navigator.pop<bool>(context, false);
                //     },
                //     child: Text('No')),
                // TextButton(
                //     onPressed: () {
                //       Navigator.pop<bool>(context, true);
                //     },
                //     child: Text('Yes')),