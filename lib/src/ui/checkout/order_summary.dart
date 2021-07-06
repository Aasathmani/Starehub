import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../src/models/app_state_model.dart';
import '../../blocs/order_summary_bloc.dart';
import '../../config.dart';
import '../../functions.dart';
import '../../models/orders_model.dart';
import '../../ui/checkout/webview.dart';

class OrderSummary extends StatefulWidget {
  final String id;
  final appStateModel = AppStateModel();
  final OrderSummaryBloc orderSummary = OrderSummaryBloc();

  OrderSummary({Key key, this.id}) : super(key: key);

  @override
  _OrderSummaryState createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {

  @override
  void initState(){
    super.initState();
    widget.orderSummary.getOrder(widget.id);
    widget.orderSummary.clearCart();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: StreamBuilder<Order>(
            stream: widget.orderSummary.order,
            builder: (context, snapshot) {
              print(snapshot.hasData);
              if (snapshot.hasData) {
                final NumberFormat formatter = NumberFormat.currency(
                    decimalDigits: snapshot.data.decimals, name: snapshot.data.currency);
                return buildOrderStatusScreen(snapshot.data, width, height, context);
              } else {
                return Center(child: CircularProgressIndicator(),);
              }
            }
        ));
  }

  Container buildOrderStatusScreen(Order order, double width, double height, BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 80),
      decoration:  BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end:
            Alignment(0.9, 0.9),
            colors:  <Color>[
              Colors.deepOrange,
              Colors.deepOrangeAccent
            ],
          )
      ),
      child: Padding(
        padding: EdgeInsets.only(top: height / 5),
        child: Stack(
          children: [
            Positioned(
                left: width *.25,
                top: height * .05,
                child: Icon(Icons.star_border,size: 30,color: Colors.deepOrange,)
            ),
            Positioned(
                right: width * -.12,
                top: height * .01,
                child: Icon(Icons.ac_unit_outlined,size: 100,color: Colors.white24,)
            ),
            Positioned(
                right: width *.25,
                top: height * .15,
                child: Icon(Icons.star_border,size: 15,color: Colors.deepOrange,)
            ),
            Positioned(
              top: 0,
              child: Container(
                height: height * .42,
                width: width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: height * .02 ,
                    ),
                    Icon(Icons.check_circle_rounded, size: 144, color: Colors.white),
                    /*Image.asset('lib/assets/images/tick_big.png',color: Colors.white,width: height * .14,
                        height:  height * .14,),*/
                    /*SizedBox(
                        height: height * .01 ,
                      ),*/
                    Text(widget.appStateModel.blocks.localeText.youOrderHaveBeenReceived,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        //letterSpacing: 1
                      ),),
                    Text(widget.appStateModel.blocks.localeText.status.toUpperCase() + ': ' + order.status.toUpperCase(),
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        //letterSpacing: 1
                      ),),
                    Text('ID' + ': ' + order.number.toUpperCase(),
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        //letterSpacing: 1
                      ),),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 25),
                      child: Text(widget.appStateModel.blocks.localeText.thankYouForShoppingWithUs,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white60,
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                          //letterSpacing: 1
                        ),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        widget.orderSummary.thankYou(order);
                        widget.appStateModel.getCart();
                        Navigator.of(context).pop();
                        Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
                        
                      },
                      child: Text('Continue'),
                      style:ButtonStyle(backgroundColor:MaterialStateProperty.all(Colors.black)),


                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ) ,
    );
  }
}