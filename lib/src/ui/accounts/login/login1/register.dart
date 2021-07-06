import 'package:flutter/material.dart';
import '../../../../config.dart';
import '../logo.dart';
import './../../../../models/app_state_model.dart';
import './../../../../models/register_model.dart';
import './../../../../ui/widgets/buttons/button.dart';
import '../../../color_override.dart';


class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final appStateModel = AppStateModel();
  RegisterModel _register = RegisterModel();
  bool _obscureText = true;
  var isLoading = false;
  final _formKey = GlobalKey<FormState>();

  TextEditingController shopUrlController = new TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Builder(
        builder: (context) => ListView(
            shrinkWrap: true,
            children: [
              SizedBox(height: 15.0),
              Container(
                margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                child:  Form(
                  key: _formKey,
                  child:  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    //crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Logo(),
                      SizedBox(
                        height: 16,),
                      PrimaryColorOverride(
                        child: TextFormField(
                          onSaved: (val) =>
                              setState(() => _register.firstName = val),
                          validator: (value) {
                            if (value.isEmpty) {
                              return appStateModel.blocks.localeText.pleaseEnterFirstName;
                            }
                            return null;
                          },
                          decoration: InputDecoration(labelText: appStateModel.blocks.localeText.firstName),
                        ),
                      ),
                      SizedBox(height: 12,),
                      PrimaryColorOverride(
                        child: TextFormField(
                          onSaved: (val) =>
                              setState(() => _register.lastName = val),
                          validator: (value) {
                            if (value.isEmpty) {
                              return appStateModel.blocks.localeText.pleaseEnterLastName;
                            }
                            return null;
                          },
                          decoration: InputDecoration(labelText: appStateModel.blocks.localeText.lastName),
                        ),
                      ),
                      SizedBox(height: 12,),
                      PrimaryColorOverride(
                        child: TextFormField(
                          onSaved: (val) =>
                              setState(() => _register.email = val),
                          validator: (value) {
                            if (value.isEmpty) {
                              return appStateModel.blocks.localeText.pleaseEnterValidEmail;
                            }
                            return null;
                          },
                          decoration: InputDecoration(labelText: appStateModel.blocks.localeText.email),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      SizedBox(height: 12,),
                      PrimaryColorOverride(
                        child: TextFormField(
                          obscureText: _obscureText,
                          onSaved: (val) =>
                              setState(() => _register.password = val),
                          validator: (value) {
                            if (value.isEmpty) {
                              return appStateModel.blocks.localeText.pleaseEnterPassword;
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText ? Icons.visibility : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  }
                              ),
                              labelText: appStateModel.blocks.localeText.password),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      if(appStateModel.blocks.vendorType == 'dokan')
                      CheckboxListTile(
                        title: Text('Register as vendor'),
                        value: _register.seller,
                        onChanged: (v) {
                          setState(() {
                            _register.seller = v;
                          });
                        },
                        contentPadding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      if(_register.seller)
                        Column(
                          children: [
                            PrimaryColorOverride(
                              child: TextFormField(
                                onSaved: (val) =>
                                    setState(() {
                                      _register.shopName = val;
                                    }),
                                validator: (value) {
                                  if (_register.seller && value.isEmpty) {
                                    return 'Please enter shop name';
                                  }
                                  return null;
                                },
                                onChanged: (val) =>
                                    setState(() {
                                      shopUrlController.text = val.toLowerCase().replaceAll(' ', '');
                                    }),
                                decoration: InputDecoration(labelText: 'Shop Name'),
                                keyboardType: TextInputType.text,
                              ),
                            ),
                            SizedBox(height: 12.0),
                            PrimaryColorOverride(
                              child: TextFormField(
                                controller: shopUrlController,
                                onSaved: (val) =>
                                    setState(() => _register.shopURL = val),
                                validator: (value) {
                                  if (_register.seller && value.isEmpty) {
                                    return 'Please enter shop url';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(labelText: 'Shop Url'),
                                keyboardType: TextInputType.text,
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Align(
                                alignment: Alignment.centerLeft, child: Text(Config().url + '/' + shopUrlController.text, textAlign: TextAlign.left,)
                            ),
                            SizedBox(height: 12.0),
                            PrimaryColorOverride(
                              child: TextFormField(
                                onSaved: (val) =>
                                    setState(() => _register.phoneNumber = val),
                                validator: (value) {
                                  if (_register.seller && value.isEmpty) {
                                    return 'Please enter phone number';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(labelText: 'Phone Number'),
                                keyboardType: TextInputType.text,
                              ),
                            ),
                          ],
                        ),
                      SizedBox(height: 30.0),
                      AccentButton(
                        onPressed: () => _submit(context),
                        text: appStateModel.blocks.localeText.signUp,
                        showProgress: isLoading,
                      ),
                      SizedBox(height: 30.0),
                      FlatButton(
                          padding: EdgeInsets.all(16.0),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  appStateModel.blocks.localeText
                                      .alreadyHaveAnAccount,
                                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                                      fontSize: 15,
                                      color: Colors.grey)),
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                    appStateModel.blocks.localeText.signIn,
                                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                                        color:
                                        Theme.of(context).accentColor)),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              ),
            ]),
      )
    );
  }

  Future _submit(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        isLoading = true;
      });
      bool status = await appStateModel.register(_register.toJson(), context);
      setState(() {
        isLoading = false;
      });
      if (status) {
        Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
      }
    }
  }

}
