import 'package:flutter/material.dart';
import '../../blocs/checkout_form_bloc.dart';
import '../../models/app_state_model.dart';
import '../../models/checkout_data_model.dart';
import 'package:place_picker/place_picker.dart';
import '../../config.dart';
import '../../functions.dart';
import '../../models/app_state_model.dart';
import '../color_override.dart';
import 'checkout_one_page.dart';


class CheckoutForm extends StatefulWidget {
  final CheckoutFormBloc checkoutFormBloc;
  final appStateModel = AppStateModel();

  CheckoutForm({Key key, this.checkoutFormBloc}) : super(key: key);
  @override
  _CheckoutFormState createState() => _CheckoutFormState();
}

class _CheckoutFormState extends State<CheckoutForm> {

  final _formKey = GlobalKey<FormState>();
  Config config = Config();

  @override
  void initState() {
    super.initState();
    widget.checkoutFormBloc.getCheckoutForm();
    widget.checkoutFormBloc.updateOrderReview();
    //widget.appStateModel.getDeliveryDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Checkout')),
      body: StreamBuilder<CheckoutFormData>(
          stream: widget.checkoutFormBloc.checkoutForm,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.all(16.0),
                  children: buildFrom(context, snapshot),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }
      ),
    );
  }

  List<Widget> buildFrom(BuildContext context, AsyncSnapshot<CheckoutFormData> snapshot) {
    List<Widget> list = new List<Widget>();

    /*list.add(
      FlatButton(
        colorBrightness: Theme.of(context).brightness,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.add_location),
            Text(
                widget.appStateModel.blocks.localeText.selectLocation)
          ],
        ),
        onPressed: () {
          showPlacePicker(snapshot);
        },
      ),
    );*/

    snapshot.data.fieldgroups.billing.forEach((element) {
      if(element.label != null) {
        if(element.type == null || element.type == 'text') {
          list.add(
            PrimaryColorOverride(
              child: TextFormField(
                initialValue: element.value,
                decoration: InputDecoration(
                    labelText: element.label,
                    hintText: element.placeholder != null ? element.placeholder : element.label
                ),
                validator: (value) {
                  if (value.isEmpty && element.required == true) {
                    return element.label + ' is required ';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    element.value = value;
                  });
                },
                onSaved: (value) {
                  element.value = value;
                },
              ),
            ),
          );
        }

        if(element.type == 'tel') {
          list.add(
            PrimaryColorOverride(
              child: TextFormField(
                initialValue: element.value,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    labelText: element.label,
                    hintText: element.placeholder != null ? element.placeholder : element.label
                ),
                validator: (value) {
                  if (value.isEmpty && element.required == true) {
                    return element.label + ' is required ';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    element.value = value;
                  });
                },
                onSaved: (value) {
                  element.value = value;
                },
              ),
            ),
          );
        }

        if(element.type == 'email') {
          list.add(
            PrimaryColorOverride(
              child: TextFormField(
                initialValue: element.value,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    labelText: element.label,
                    hintText: element.placeholder != null ? element.placeholder : element.label
                ),
                validator: (value) {
                  if (value.isEmpty && element.required == true) {
                    return element.label + ' is required ';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    element.value = value;
                  });
                },
                onSaved: (value) {
                  element.value = value;
                },
              ),
            ),
          );
        }

        if(element.type == 'country' && element.dotappOptions.length > 0) {
          list.add(
            Column(
              children: [
                SizedBox(
                  height: 16,
                ),
                DropdownButton<String>(
                  value: element.value,
                  hint: Text(element.label),
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  underline: Container(
                    height: 2,
                    color: Theme.of(context).dividerColor,
                  ),
                  onChanged: (String newValue) {
                    if(snapshot.data.fieldgroups.billing.any((element) => element.type == 'state')) {
                      snapshot.data.fieldgroups.billing.firstWhere((element) => element.type == 'state').value = '';
                    }
                    setState(() {
                      widget.checkoutFormBloc.selectedCountry = newValue;
                      element.value = newValue;
                    });
                  },
                  items: element.dotappOptions.map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                      value: value.value != null ? value.value : '',
                      child: Text(parseHtmlString(value.label)),
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        }

        if(element.type == 'select' && element.dotappOptions.length > 0) {
          DotappOption selectedOption;
          if(element.dotappOptions.any((option) => option.value == element.value)) {
            selectedOption = element.dotappOptions.firstWhere((option) => option.value == element.value);
          } else selectedOption = element.dotappOptions.first;
          list.add(
            Column(
              children: [
                SizedBox(
                  height: 16,
                ),
                DropdownButton<DotappOption>(
                  value: selectedOption,
                  hint: Text(element.label),
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  underline: Container(
                    height: 2,
                    color: Theme.of(context).dividerColor,
                  ),
                  onChanged: (DotappOption newValue) {
                    widget.checkoutFormBloc.formData[element.key] = newValue.value;
                    setState(() {
                      element.value = newValue.value;
                    });
                  },
                  items: element.dotappOptions.map<DropdownMenuItem<DotappOption>>((value) {
                    return DropdownMenuItem<DotappOption>(
                      value: value,
                      child: value.value != null ? Text(parseHtmlString(value.value)) : Container(),
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        }

        if(element.type == 'state' && snapshot.data.fieldgroups.billing.any((element) => element.type == 'country')) {
          if(snapshot.data.fieldgroups.billing.firstWhere((element) => element.type == 'country').dotappOptions.any((country) => country.value == widget.checkoutFormBloc.selectedCountry))
            if(snapshot.data.fieldgroups.billing.firstWhere((element) => element.type == 'country').dotappOptions.singleWhere((country) => country.value == widget.checkoutFormBloc.selectedCountry).regions.length > 0) {
              if(!snapshot.data.fieldgroups.billing.firstWhere((element) => element.type == 'country').dotappOptions.singleWhere((country) => country.value == widget.checkoutFormBloc.selectedCountry).regions.any((s) => s.value == element.value)) {
                element.value = snapshot.data.fieldgroups.billing.firstWhere((element) => element.type == 'country').dotappOptions.singleWhere((country) => country.value == widget.checkoutFormBloc.selectedCountry).regions.first.value;
              }
              list.add(
                Column(
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    DropdownButton<String>(
                      value: element.value,
                      hint: Text(element.label),
                      isExpanded: true,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      underline: Container(
                        height: 2,
                        color: Theme.of(context).dividerColor,
                      ),
                      onChanged: (String newValue) {
                        widget.checkoutFormBloc.formData['billing_state'] = '';
                        widget.checkoutFormBloc.formData['shipping_state'] = '';
                        setState(() {
                          element.value = newValue;
                        });
                      },
                      items: snapshot.data.fieldgroups.billing.firstWhere((element) => element.type == 'country').dotappOptions.singleWhere((country) => country.value == widget.checkoutFormBloc.selectedCountry).regions.map<DropdownMenuItem<String>>((value) {
                        return DropdownMenuItem<String>(
                          value: value.value != null ? value.value : '',
                          child: Text(parseHtmlString(value.label)),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            }
        }

        if(element.type == 'state' && snapshot.data.fieldgroups.billing.any((element) => element.value == widget.checkoutFormBloc.selectedCountry))
          if(snapshot.data.fieldgroups.billing.firstWhere((element) => element.value == widget.checkoutFormBloc.selectedCountry).dotappOptions.any((country) => country.value == widget.checkoutFormBloc.selectedCountry))
            if(snapshot.data.fieldgroups.billing.firstWhere((element) => element.value == widget.checkoutFormBloc.selectedCountry).dotappOptions.singleWhere((country) => country.value == widget.checkoutFormBloc.selectedCountry).regions.length == 0) {
              list.add(
                PrimaryColorOverride(
                  child: TextFormField(
                    initialValue: element.value,
                    decoration: InputDecoration(
                        labelText: element.label),
                    validator: (value) {
                      if (value.isEmpty && element.required == true) {
                        return element.label + ' is required ';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      element.value = value;
                    },
                  ),
                ),
              );
            }
      }
    });

    list.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: RaisedButton(
            child: Text(widget.appStateModel.blocks.localeText.localeTextContinue),
            onPressed: () {
              widget.checkoutFormBloc.formData['security'] = snapshot.data.data.nonce.updateOrderReviewNonce;
              widget.checkoutFormBloc
                  .formData['woocommerce-process-checkout-nonce'] = snapshot.data.data.wpnonce;
              widget.checkoutFormBloc.formData['wc-ajax'] = 'update_order_review';
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                bool pass = true;
                for(final element in snapshot.data.fieldgroups.billing) {
                  if(element.value != null && element.value.isNotEmpty)
                    widget.checkoutFormBloc.formData[element.key] = element.value;
                  else if(element.required == true) {
                    showSnackBarError(context, element.label + ' is required');
                    pass = false;
                    break;
                  }
                }
                widget.checkoutFormBloc.updateOrderReview2();
                if(pass == true)
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CheckoutOnePage(
                            checkoutFormBloc: widget.checkoutFormBloc,
                          )));
              }
            },
          ),
        )
    );

    return list;
  }

  void showPlacePicker(AsyncSnapshot<CheckoutFormData> snapshot) async {
    LocationResult result = await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PlacePicker(config.mapApiKey)));
    if (result != null) {
      if(snapshot.data.fieldgroups.billing.any((element) => element.key == 'billing_address_2')) {
        snapshot.data.fieldgroups.billing.firstWhere((element) => element.key == 'billing_address_2').value = result.formattedAddress;
      }
      if(snapshot.data.fieldgroups.billing.any((element) => element.key == 'billing_city')) {
        snapshot.data.fieldgroups.billing.firstWhere((element) => element.key == 'billing_city').value = result.city.name;
      }
      if(snapshot.data.fieldgroups.billing.any((element) => element.key == 'billing_postcode')) {
        snapshot.data.fieldgroups.billing.firstWhere((element) => element.key == 'billing_postcode').value = result.postalCode;
      }
      snapshot.data.fieldgroups.billing.forEach((element) {
        if(element.type == 'country' && element.dotappOptions.length > 0) {
          if (element.dotappOptions.indexWhere(
                  (country) => country.value == result.country.shortName) !=
              -1) {
            element.value = result.country.shortName;
          }
        }
        if(element.type == 'state' && element.dotappOptions.length > 0) {
          if (element.dotappOptions.indexWhere(
                  (state) => state.value == result.administrativeAreaLevel1.shortName) !=
              -1) {
            element.value = result.administrativeAreaLevel1.shortName;
          }
        }
      });
      setState(() {});
    }
  }
}
