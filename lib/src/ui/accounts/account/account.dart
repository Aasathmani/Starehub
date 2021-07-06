import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import './../../../models/app_state_model.dart';
import 'account1.dart';
import 'account2.dart';
import 'account3.dart';
import 'account4.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {
          print(model.blocks.pageLayout.account);
          if (model.blocks.pageLayout.account == 'layout1') {
            return UserAccount1();
          } else if (model.blocks.pageLayout.account == 'layout2') {
            return UserAccount4();
          } else if (model.blocks.pageLayout.account == 'layout3') {
            return UserAccount3();
          } else if (model.blocks.pageLayout.account == 'layout4') {
            return UserAccount4();
          } else if (model.blocks.pageLayout.account == 'layout4') {
            return UserAccount3();
          } else {
            return UserAccount1();
          }
        });
  }
}


