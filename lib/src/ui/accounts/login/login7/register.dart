import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import './../../../../ui/accounts/login/login7/bezierContainer.dart';
import './../../../../models/app_state_model.dart';
import './../../../../ui/accounts/login/login5/clipper.dart';
import './../../../../ui/color_override.dart';

import 'theme_override.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final appStateModel = AppStateModel();
  var formData = new Map<String, dynamic>();
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return ThemeOverride(
      child: Builder(
        builder: (context) => AnnotatedRegion<SystemUiOverlayStyle>(
          value:
              isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
          child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
            body: Builder(
              builder: (context) => Stack(
                children: [
                  Positioned(
                    top: height * -.16,
                    //means -150 of total height; i.e above the screen
                    right: MediaQuery.of(context).size.width * -.45,
                    //means -40% of total width; i.e more than  right the screen
                    child: BezierContainer(),
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        children: [
                          Lottie.asset(
                            'lib/assets/images/intro/food_cooking.json',
                            width: 220,
                            height: 220,
                          ),
                          PrimaryColorOverride(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  appStateModel.blocks.localeText.firstName,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  style: TextStyle(color: Colors.black),
                                  onSaved: (value) => setState(
                                      () => formData['first_name'] = value),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return appStateModel.blocks.localeText
                                          .pleaseEnterFirstName;
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    //suffixIcon: obscureText == true ? Icon(Icons.remove_red_eye) : Container(),
                                    hintText: appStateModel
                                        .blocks.localeText.firstName,
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.025,
                          ),
                          PrimaryColorOverride(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  appStateModel.blocks.localeText.lastName,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  style: TextStyle(color: Colors.black),
                                  onSaved: (value) => setState(
                                      () => formData['last_name'] = value),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return appStateModel.blocks.localeText
                                          .pleaseEnterLastName;
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    //suffixIcon: obscureText == true ? Icon(Icons.remove_red_eye) : Container(),
                                    hintText: appStateModel
                                        .blocks.localeText.lastName,
                                  ),
                                  keyboardType: TextInputType.text,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.025,
                          ),
                          PrimaryColorOverride(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  appStateModel.blocks.localeText.email,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  style: TextStyle(color: Colors.black),
                                  onSaved: (value) =>
                                      setState(() => formData['email'] = value),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return appStateModel.blocks.localeText
                                          .pleaseEnterValidEmail;
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    //suffixIcon: obscureText == true ? Icon(Icons.remove_red_eye) : Container(),
                                    hintText:
                                        appStateModel.blocks.localeText.email,
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.025,
                          ),
                          PrimaryColorOverride(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  appStateModel.blocks.localeText.password,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  style: TextStyle(color: Colors.black),
                                  onSaved: (value) => setState(
                                      () => formData['password'] = value),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return appStateModel.blocks.localeText
                                          .pleaseEnterPassword;
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    //suffixIcon: obscureText == true ? Icon(Icons.remove_red_eye) : Container(),
                                    hintText: appStateModel
                                        .blocks.localeText.password,
                                  ),
                                  obscureText: true,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.025,
                          ),
                          RoundedLoadingButton(
                            borderRadius: 0,
                            color: Theme.of(context).buttonColor,
                            elevation: 0,
                            valueColor: Theme.of(context)
                                .buttonTheme
                                .colorScheme
                                .onPrimary,
                            child: Text(appStateModel.blocks.localeText.signUp, style: TextStyle(color: Theme.of(context)
                                .buttonTheme
                                .colorScheme
                                .onPrimary),),
                            controller: _btnController,
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                _submit(context);
                              }
                            },
                            animateOnTap: false,
                            width: MediaQuery.of(context).size.width - 34,
                          ),
                          SizedBox(height: 10.0),
                          FlatButton(
                              padding: EdgeInsets.all(16.0),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(appStateModel.blocks.localeText.alreadyHaveAnAccount,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                            fontSize: 15,
                                          )),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(appStateModel.blocks.localeText.signIn,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .buttonColor,
                                                fontWeight: FontWeight.w500)),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future _submit(BuildContext context) async {
    _btnController.start();
    bool status = await appStateModel.register(formData, context);
    if (status) {
      Navigator.popUntil(
          context, ModalRoute.withName(Navigator.defaultRouteName));
    }
    _btnController.stop();
  }

  onSaved(String value, String field) {
    formData[field] = value;
  }

  onValidate(String value, String label) {
    if (value.isEmpty) {
      return label + ' ' + appStateModel.blocks.localeText.isRequired;
    }
    return null;
  }
}
