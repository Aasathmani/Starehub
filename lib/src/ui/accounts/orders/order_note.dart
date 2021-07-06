import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:url_launcher/url_launcher.dart';

import './../../../blocs/order_notes_bloc.dart';
import './../../../functions.dart';
import './../../../models/order_notes_model.dart';
import './../../../models/orders_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderNotes extends StatefulWidget {
  final Order order;
  final orderNotes = OrderNotesBloc();
  OrderNotes({Key key, this.order}) : super(key: key);
  @override
  _OrderNotesState createState() => _OrderNotesState();
}

class _OrderNotesState extends State<OrderNotes> {
  ScrollController _scrollController = new ScrollController();

  bool hasMoreOrders = false;

  @override
  void initState() {
    widget.orderNotes.orderId = widget.order.id.toString();
    widget.orderNotes.filter['type'] = 'customer';
    widget.orderNotes.fetchItems();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        widget.orderNotes.fetchItems();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Notes'),
      ),
      body: StreamBuilder(
          stream: widget.orderNotes.allNotes,
          builder: (context, AsyncSnapshot<List<OrderNote>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length == 0) {
                return Center(child: Text('No order notes yet!'));
              } else {
                return CustomScrollView(
                  controller: _scrollController,
                  slivers: <Widget>[
                    buildList(snapshot),
                  ],
                );
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  buildList(AsyncSnapshot<List<OrderNote>> snapshot) {
    var formatter1 = new DateFormat('yyyy-MM-dd  hh:mm a');
    return SliverPadding(
      padding: EdgeInsets.all(0.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Padding(
              padding: const EdgeInsets.all(0.0),
              child: Card(
                  elevation: 0.5,
                  margin: EdgeInsets.all(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                    ListTile(
                        title: Container(
                            child: Html(
                              data: snapshot.data[index].note,
                              onLinkTap: (url) async {
                                print(launch);
                                if (url.contains('https://wa.me')) {
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  } else {
                                    throw 'Could not launch $url';
                                  }
                                } else launch(url);
                              },
                            ),//Text(parseHtmlString(snapshot.data[index].note))
                        ),
                        subtitle: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(formatter1.format(snapshot.data[index].dateCreated)),
                            ],
                          ),
                        )),
                  )),
            );
          },
          childCount: snapshot.data.length,
        ),
      ),
    );
  }
}
