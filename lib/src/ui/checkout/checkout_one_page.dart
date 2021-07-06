import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:scoped_model/scoped_model.dart';
//import 'package:stripe_payment/stripe_payment.dart';
import '../../blocs/payment/paystack_bloc.dart';
import '../../models/payment/payment_verification_response.dart';
import '../../blocs/checkout_form_bloc.dart';
import '../widgets/buttons/button_text.dart';
import '../../blocs/checkout_bloc.dart';
import '../../functions.dart';
import '../../models/app_state_model.dart';
import '../../models/checkout/order_result_model.dart';
import '../../models/checkout/order_review_model.dart';
import '../../models/checkout/stripeSource.dart' hide Card;
import '../../models/checkout/stripe_token.dart' hide Card;
import '../../ui/checkout/webview.dart';
import '../color_override.dart';
import 'order_summary.dart';
import 'payment/payment_card.dart';
import 'payment/webview_submit.dart';
import 'package:intl/intl.dart';

class CheckoutOnePage extends StatefulWidget {
  final CheckoutFormBloc checkoutFormBloc;
  final appStateModel = AppStateModel();
  CheckoutOnePage({this.checkoutFormBloc});
  @override
  _CheckoutOnePageState createState() => _CheckoutOnePageState();
}

class _CheckoutOnePageState extends State<CheckoutOnePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  var isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.appStateModel.blocks.localeText.checkout),
      ),
      body: SafeArea(
        child: StreamBuilder<OrderReviewModel>(
            stream: widget.checkoutFormBloc.orderReview,
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? _buildCheckoutForm(snapshot, context)
                  : Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }

  Widget _buildCheckoutForm(
      AsyncSnapshot<OrderReviewModel> snapshot, BuildContext context) {
    return ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {
          return CustomScrollView(
            slivers: slivers(snapshot, context, model),
          );
        });
  }

  List<Widget> slivers(AsyncSnapshot<OrderReviewModel> snapshot,
      BuildContext context, AppStateModel model) {

    TextStyle subhead = Theme.of(context).textTheme.headline6;

    List<Widget> list = new List<Widget>();

    if (snapshot.data.shipping.length > 0) {
      for (var i = 0; i < snapshot.data.shipping.length; i++) {
        if (snapshot.data.shipping[i].shippingMethods.length > 0) {
          list.add(SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 8.0),
                child: Text(
                  parseHtmlString(snapshot.data.shipping[i].packageName),
                  style: subhead,
                ),
              )));

          list.add(_buildShippingList(snapshot, i));
        }
      }

      list.add(SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
            child: Divider(
              color: Theme.of(context).dividerColor,
              height: 10.0,
            ),
          )));
    }

    if(model.deliveryDate?.bookableDates != null && model.deliveryDate.bookableDates.length > 0) {
      list.add(
          _buildDeliveryDate(model)
      );

      if(model.deliverySlot != null && model.deliverySlot[model.selectedDate]?.slots != null) {
        list.add(
            _buildDeliveryTimeSlot(model)
        );
      } else {
        list.add(
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: CircularProgressIndicator()),
              ),
            )
        );
      }
    }

    if(snapshot.data.paymentMethods.length > 0) {
      list.add(SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 8.0),
            child: Text(
              widget.appStateModel.blocks.localeText.paymentMethod,
              style: subhead,
            ),
          )));

      list.add(_buildPaymentList(snapshot));
    }

    if(['dear_eko_wmbp_eko','dear_paym_wmbp_paym','dear_pesa_wmbp_pesa'].contains(widget.checkoutFormBloc.formData['payment_method'])) {
      list.add(_dearPesaPayament());
    }

    list.add(SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 8.0),
          child: Text(
            widget.appStateModel.blocks.localeText.order,
            style: subhead,
          ),
        )));
    list.add(_buildOrderList(snapshot));

    list.add(SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            RaisedButton(
              child: ButtonText(
                  isLoading: isLoading,
                  text: widget
                      .appStateModel.blocks.localeText.localeTextContinue),
              onPressed: () => isLoading ? null : _placeOrder(context, snapshot),
            ),
            StreamBuilder<OrderResult>(
                stream: widget.checkoutFormBloc.orderResult,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data.result == "failure") {
                    return Center(
                      child: Container(
                          padding: EdgeInsets.all(16),
                          child: Text(parseHtmlString(snapshot.data.messages),
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2
                                  .copyWith(
                                  color: Theme.of(context).errorColor))),
                    );
                  } else if (snapshot.hasData &&
                      snapshot.data.result == "success") {
                    return Container();
                  } else {
                    return Container();
                  }
                }),
          ],
        ),
      ),
    ));

    return list;
  }

  _buildShippingList(AsyncSnapshot<OrderReviewModel> snapshot, int i) {
    print(snapshot.data.shipping[i].shippingMethods.length);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
          print(snapshot.data.shipping[i].shippingMethods[index].label);
          return RadioListTile<String>(
            value: snapshot.data.shipping[i].shippingMethods[index].id,
            groupValue: snapshot.data.shipping[i].chosenMethod,
            onChanged: (String value) {
              setState(() {
                snapshot.data.shipping[i].chosenMethod = value;
              });
              widget.checkoutFormBloc.updateOrderReview2();
            },
            title: Text(snapshot.data.shipping[i].shippingMethods[index].label +
                ' ' +
                parseHtmlString(
                    snapshot.data.shipping[i].shippingMethods[index].cost)),
          );
        },
        childCount: snapshot.data.shipping[i].shippingMethods.length,
      ),
    );
  }

  _buildDeliveryDate(AppStateModel model) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(8),
        height: 100.0,
        width: 120.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: model.deliveryDate.bookableDates.length,
          itemBuilder: (context, index) {
            List<String> str =
            model.deliveryDate.bookableDates[index].split('/');
            DateTime now = new DateTime(
                int.parse(str[2]), int.parse(str[1]), int.parse(str[0]));
            final DateFormat formatter = DateFormat('EEEE, dd MMM');
            final String formatted = formatter.format(now);
            // DateFormat.yMMMEd().format(dt);
            //final String formatted = DateFormat.MMMEd().format(now);
            String date = str[2] + str[1] + str[0];
            return Container(
              width: MediaQuery.of(context).size.width * 0.32,
              child: GestureDetector(
                child: Card(
                  color: model.selectedDate == date
                      ? Color(0xff027dcb)
                      : Colors.white,
                  child: InkWell(
                    highlightColor: Colors.deepOrangeAccent,
                    borderRadius: BorderRadius.circular(4.0),
                    onTap: () async {
                      setState(() {
                        isLoading = false;
                      });
                      model.setDate(date, model.deliveryDate.bookableDates[index]);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: ListTile(
                        //title: Text(widget.appStateModel.blocks.localeText.address, style: Theme.of(context).textTheme.subtitle),
                        subtitle: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Center(
                              child: Text(
                                formatted,
                                style: TextStyle(
                                  color: model.selectedDate ==
                                      date
                                      ? Colors.white
                                      : Color(0xff027dcb),
                                ),
                              )),
                        ),
                      ),

                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _buildDeliveryTimeSlot(AppStateModel model) {
    double cWidth = MediaQuery.of(context).size.width * 0.8;
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
          return RadioListTile(
            value: model
                .deliverySlot[model.selectedDate]
                .slots[index]
                .value,
            groupValue: model.selectedTime,
            onChanged: (String value) {
              setState(() {
                isLoading = false;
              });
              model.setDeliveryTime(value);
            },
            title: Container(
                width: cWidth,
                child: Text(model
                    .deliverySlot[model.selectedDate]
                    .slots[index]
                    .formatted)),
          );
        },
        childCount: model
            .deliverySlot[model.selectedDate]
            .slots
            .length,
      ),
    );
  }

  _buildPaymentList(AsyncSnapshot<OrderReviewModel> snapshot) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
          Widget paymentTitle = snapshot.data.paymentMethods[index].id == 'wallet' ? Row(
            children: [
              Text(parseHtmlString(snapshot.data.paymentMethods[index].title)),
              SizedBox(width: 8),
              Text(parseHtmlString(snapshot.data.balanceFormatted), style: Theme.of(context).textTheme.subtitle2,)
            ],
          ) : Text(parseHtmlString(snapshot.data.paymentMethods[index].title));
          return RadioListTile<String>(
            value: snapshot.data.paymentMethods[index].id,
            groupValue: widget.checkoutFormBloc.formData['payment_method'],
            onChanged: (String value) {
              setState(() {
                isLoading = false;
                widget.checkoutFormBloc.formData['payment_method'] = value;
              });
              widget.checkoutFormBloc.updateOrderReview2();
            },
            title: paymentTitle,
          );
        },
        childCount: snapshot.data.paymentMethods.length,
      ),
    );
  }

  _buildOrderList(AsyncSnapshot<OrderReviewModel> snapshot) {
    final smallAmountStyle = Theme.of(context).textTheme.body1;
    final largeAmountStyle = Theme.of(context).textTheme.title;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 0.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                      widget.appStateModel.blocks.localeText.subtotal + ':'),
                ),
                Text(
                  parseHtmlString(snapshot.data.totals.subtotal),
                  style: smallAmountStyle,
                ),
              ],
            ),
            const SizedBox(height: 4.0),
            Row(
              children: [
                Expanded(
                  child: Text(
                      widget.appStateModel.blocks.localeText.shipping + ':'),
                ),
                Text(
                  parseHtmlString(snapshot.data.totals.shippingTotal),
                  style: smallAmountStyle,
                ),
              ],
            ),
            const SizedBox(height: 4.0),
            Row(
              children: [
                Expanded(
                  child: Text(widget.appStateModel.blocks.localeText.tax + ':'),
                ),
                Text(
                  parseHtmlString(snapshot.data.totals.totalTax),
                  style: smallAmountStyle,
                ),
              ],
            ),
            const SizedBox(height: 4.0),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(widget.appStateModel.blocks.localeText.discount),
                ),
                Text(
                  parseHtmlString(snapshot.data.totals.discountTotal),
                  style: smallAmountStyle,
                ),
              ],
            ),
            const SizedBox(height: 6.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    widget.appStateModel.blocks.localeText.total,
                    style: largeAmountStyle,
                  ),
                ),
                Text(
                  parseHtmlString(snapshot.data.totals.total),
                  style: largeAmountStyle,
                ),
              ],
            ),
            const SizedBox(height: 6.0),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: PrimaryColorOverride(
                      child: TextFormField(
                        maxLines: 2,
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          labelText: widget.appStateModel.blocks.localeText.orderNote,
                          errorMaxLines: 1,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 0.5),
                          ),
                        ),
                        onChanged: (value) {
                          widget.checkoutFormBloc.formData['order_comments'] = value;
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  openWebView(String url)  async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WebViewPage(
                url: url,
                selectedPaymentMethod:
                widget.checkoutFormBloc.formData['payment_method'])));
    setState(() {
      isLoading = false;
    });
  }

  webViewSubmit()  async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WebViewSubmit(checkoutBloc: widget.checkoutFormBloc)));
    setState(() {
      isLoading = false;
    });
  }

  void orderDetails(OrderResult orderResult) {
    var orderId = getOrderIdFromUrl(orderResult.redirect);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OrderSummary(
              id: orderId,
            )));
  }

  _placeOrder(BuildContext context, AsyncSnapshot<OrderReviewModel> snapshot) async {

    setState(() {
      isLoading = true;
    });

    //if(widget.homeBloc.formData['payment_method'] == 'eh_stripe_checkout') {
    //webViewSubmit();
    //}

    if (widget.checkoutFormBloc.formData['payment_method'] == 'stripe') {
      _processStripePayment(snapshot);
    } else {
      OrderResult orderResult = await widget.checkoutFormBloc.placeOrder();
      if (orderResult.result == 'success') {
        if (widget.checkoutFormBloc.formData['payment_method'] == 'cod' ||
            widget.checkoutFormBloc.formData['payment_method'] == 'wallet' ||
            widget.checkoutFormBloc.formData['payment_method'] == 'cheque' ||
            widget.checkoutFormBloc.formData['payment_method'] == 'bacs' ||
            widget.checkoutFormBloc.formData['payment_method'] == 'paypalpro') {
          orderDetails(orderResult);
          setState(() {
            isLoading = false;
          });
        } else if (widget.checkoutFormBloc.formData['payment_method'] == 'payuindia' ||
            widget.checkoutFormBloc.formData['payment_method'] == 'paytm') {
          openWebView(orderResult.redirect);
          setState(() {
            isLoading = false;
          });
          //Navigator.push(context, MaterialPageRoute(builder: (context) => PaytmPage()));
        } else if (widget.checkoutFormBloc.formData['payment_method'] == 'woo_mpgs') {
          bool status = await widget.checkoutFormBloc
              .processCredimaxPayment(orderResult.redirect);
          openWebView(orderResult.redirect);
          setState(() {
            isLoading = false;
          });
        } else if (widget.checkoutFormBloc.formData['payment_method'] == 'razorpay') {
          openWebView(orderResult.redirect);
          //processRazorPay(snapshot, orderResult); // Uncomment this for SDK Payment
          openWebView(orderResult.redirect); // Uncomment this for Webview Payment
        } else if (widget.checkoutFormBloc.formData['payment_method'] == 'paystack') {
          processPayStack(context, snapshot, orderResult); // Uncomment this for SDK Payment
          //openWebView(orderResult.redirect); // Uncomment this for Webview Payment
        } else {
          openWebView(orderResult.redirect);
          setState(() {
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
        // Order result is faliure
      }
    }
  }

  /// PayStack Payment.
  Future<void> processPayStack(BuildContext context, AsyncSnapshot<OrderReviewModel> snapshot, OrderResult orderResult) async {
    PaymentVerificationResponse paymentStatus = await PayStackPaymentBloc().processPayStack(context, widget.checkoutFormBloc.formData['billing_email'], snapshot.data, orderResult);
    setState(() => isLoading = false);
    if(paymentStatus.status == true) {
      orderDetails(orderResult);
    } else {
      showSnackBarError(context, paymentStatus.message);
    }
  }

  /// RazorPay Payment.
  Future<void> processRazorPay(
      AsyncSnapshot<OrderReviewModel> snapshot, OrderResult orderResult) {
    /*
    var orderId = getOrderIdFromUrl(orderResult.redirect);
    Razorpay _razorPay;
    _razorPay = Razorpay();
    _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentSuccessResponse response) {
    Fluttertoast.showToast(msg: "SUCCESS"+response.paymentId);
      orderDetails(orderResult);
    });
    _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    var options = {
      'key': snapshot.data.paymentMethods.singleWhere((method) => method.id == 'razorpay').settings.razorPayKeyId,
      'amount': num.parse(snapshot.data.totalsUnformatted.total) * 100,
      'name': widget.homeBloc.formData['billing_name'],
      'description': 'Payment for Order' + orderId,
      'profile': {'contact': '', 'email': widget.homeBloc.formData['billing_email'],
        'external': {
          'wallets': ['paytm']
        }}
    };
    try{
      _razorPay.open(options);
      setState(() { isLoading = false; });
    }
    catch(e){
      setState(() { isLoading = false; });
      debugPrint(e);
    }*/
  }

  /*void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(msg: "SUCCESS"+response.paymentId);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: "ERROR"+response.code.toString()+ '-' + response.message) ;
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "EXTERNAL WALLET" + response.walletName);
  }*/

  Future<void> _processStripePayment(
      AsyncSnapshot<OrderReviewModel> snapshot) async {
    String stripePublicKey = snapshot.data.paymentMethods
        .singleWhere((method) => method.id == 'stripe')
        .stripePublicKey;

    //TODO Uncomment for stripe payment
    /*StripePayment.setOptions(StripeOptions(
        publishableKey: stripePublicKey,
        merchantId: "Test",
        androidPayMode: 'test'));*/

    Charge charge = Charge()
      ..amount = num.parse(snapshot.data.totalsUnformatted.total).round()
      ..email = widget.checkoutFormBloc.formData['billing_email'];

    PaymentCard paymentMethod = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => new CheckoutWidget(
          charge: charge,
          fullscreen: false,
          total: snapshot.data.totals.total,
          logo: Container(
            child:
            Image.asset('lib/assets/images/stripe_logo_slate_sm.png'),
          ),
        ));
    if (paymentMethod != null) {
      var stripeTokenParams = new Map<String, dynamic>();

      stripeTokenParams['key'] = stripePublicKey;
      stripeTokenParams['payment_user_agent'] =
      'stripe.js/477704d9; stripe-js-v3/477704d9';
      stripeTokenParams['card[number]'] = paymentMethod.number.toString();
      stripeTokenParams['card[cvc]'] = paymentMethod.cvc.toString();
      stripeTokenParams['card[exp_month]'] =
          paymentMethod.expiryMonth.toString();
      stripeTokenParams['card[exp_year]'] = paymentMethod.expiryYear.toString();
      stripeTokenParams['card[name]'] =
      widget.checkoutFormBloc.formData['billing_last_name'];
      stripeTokenParams['card[address_line1]'] =
      widget.checkoutFormBloc.formData['billing_address_1'] != null
          ? widget.checkoutFormBloc.formData['billing_address_1']
          : '';
      stripeTokenParams['card[address_line2]'] =
      widget.checkoutFormBloc.formData['billing_address_2'] != null
          ? widget.checkoutFormBloc.formData['billing_address_2']
          : '';
      stripeTokenParams['card[address_state]'] =
      widget.checkoutFormBloc.formData['billing_state'] != null
          ? widget.checkoutFormBloc.formData['billing_state']
          : '';
      stripeTokenParams['card[address_city]'] =
      widget.checkoutFormBloc.formData['billing_city'] != null
          ? widget.checkoutFormBloc.formData['billing_city']
          : '';
      stripeTokenParams['card[address_zip]'] =
      widget.checkoutFormBloc.formData['billing_postcode'] != null
          ? widget.checkoutFormBloc.formData['billing_postcode']
          : '';
      stripeTokenParams['card[address_country]'] =
      widget.checkoutFormBloc.formData['billing_country'] != null
          ? widget.checkoutFormBloc.formData['billing_country']
          : '';

      StripeTokenModel stripeToken =
      await widget.checkoutFormBloc.getStripeToken(stripeTokenParams);

      var stripeSourceParams = new Map<String, dynamic>();
      stripeSourceParams['type'] = 'card';
      stripeSourceParams['token'] = stripeToken.id;
      stripeSourceParams['key'] = stripeTokenParams['key'];

      StripeSourceModel stripeSource =
      await widget.checkoutFormBloc.getStripeSource(stripeSourceParams);

      widget.checkoutFormBloc.formData['stripe_source'] = stripeSource.id;
      widget.checkoutFormBloc.formData['wc-stripe-payment-token'] = 'new';

      OrderResult orderResult = await widget.checkoutFormBloc.placeOrder();

      orderDetails(orderResult);
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _dearPesaPayament() {
    switch (widget.checkoutFormBloc.formData['payment_method']) {
      case 'dear_eko_wmbp_eko':
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('How to pay', style: Theme.of(context).textTheme.headline6,),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('1. Dial *150*01#'),
                      Text('2. Select 5 – Pay Merchant'),
                      Text('3. Select 2 – Pay Masterpass QR Merchant'),
                      //REPLACE MERCHANT NUMBER WITH ACTUAL
                      Text('4. Enter 8-digit Merchant Number “60269974”'),
                      Text('5. Enter Amount'),
                      Text('6. Enter PIN to confirm'),
                      Text('7. You will receive confirmation SMS'),
                      Text('8. Fill Up The Form Below'),
                    ],
                  ),
                ),
                PrimaryColorOverride(
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Type Your Tigo-Pesa Number Used To Pay<',
                        hintText: 'e.g 0712XXXXXX'
                    ),
                    onChanged: (value) {
                      setState(() {
                        widget.checkoutFormBloc.formData['wmbp_eko_number']  = value;
                      });
                    },
                  ),
                ),
                PrimaryColorOverride(
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Type the TransID from the SMS sent to your Mobile No. Used To Pay',
                        hintText: 'e.g 1D2345X67BZ'
                    ),
                    onChanged: (value) {
                      setState(() {
                        widget.checkoutFormBloc.formData['wmbp_eko_transaction_id']  = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      case 'dear_paym_wmbp_paym':
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('How to pay', style: Theme.of(context).textTheme.headline6,),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('1. Dial *150*60#'),
                      Text('2. Select 5 – Make Payments'),
                      Text('3. Select 1 – Merchant Payments'),
                      Text('4. Select 1 – Pay with SelcomPay/Masterpass'),
                      Text('6. Enter Amount'),
                      //REPLACE MERCHANT NUMBER WITH ACTUAL
                      Text('6. Enter Merchant Number “60269974”'),
                      Text('7. Enter PIN to confirm'),
                      Text('8. You will receive confirmation SMS'),
                      Text('9. Fill Up The Form Below'),
                    ],
                  ),
                ),
                PrimaryColorOverride(
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Type Your Airtel Number Used To Pay',
                        hintText: 'e.g 078XXXXXXX'
                    ),
                    onChanged: (value) {
                      setState(() {
                        widget.checkoutFormBloc.formData['wmbp_paym_number']  = value;
                      });
                    },
                  ),
                ),
                PrimaryColorOverride(
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Type the TransID from the SMS sent to your Airtel No. Used To Pay',
                        hintText: 'e.g 123BX456X12BZ'
                    ),
                    onChanged: (value) {
                      setState(() {
                        widget.checkoutFormBloc.formData['wmbp_paym_transaction_id']  = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      case 'dear_pesa_wmbp_pesa':
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('How to pay', style: Theme.of(context).textTheme.headline6,),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('1. Dial *150*00#'),
                      Text('2. Choose 4 – Lipa by M-Pesa'),
                      Text('3. Choose 4 – Enter Business Number'),
                      Text('4. Enter “123123” (As Selcom Pay/Masterpass Number)'),
                      //REPLACE MERCHANT NUMBER WITH ACTUAL
                      Text('5. Enter Reference Number “60269974”'),
                      Text('6. Enter Amount'),
                      Text('7. Enter PIN to confirm'),
                      Text('8. You will receive confirmation SMS'),
                      Text('9. Fill Up The Form Below'),
                    ],
                  ),
                ),
                PrimaryColorOverride(
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Type Your M-Pesa No. Used To Pay',
                        hintText: 'e.g 0752XXXXXX'
                    ),
                    onChanged: (value) {
                      setState(() {
                        widget.checkoutFormBloc.formData['wmbp_pesa_number']  = value;
                      });
                    },
                  ),
                ),
                PrimaryColorOverride(
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Type the TransID from the SMS sent to your Mobile No. Used To Pay',
                        hintText: 'e.g 6D4256X68BZ'
                    ),
                    onChanged: (value) {
                      setState(() {
                        widget.checkoutFormBloc.formData['wmbp_pesa_transaction_id']  = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      default:
        return SliverToBoxAdapter();
    }


  }
}
