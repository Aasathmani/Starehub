import 'package:app/src/ui/appointments/appointments_form.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../models/app_state_model.dart';
import 'store_list.dart';
import 'search_store.dart';

import '../../../../models/vendor/store_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../../../models/vendor/store_state_model.dart';

class Stores extends StatefulWidget {
  final Map<String, dynamic> filter;
  final StoreStateModel model = StoreStateModel();

  Stores({Key key, this.filter}) : super(key: key);
  @override
  _StoresState createState() => _StoresState();
}

class _StoresState extends State<Stores> {
  ScrollController _scrollController = new ScrollController();
  AppStateModel appStateModel = AppStateModel();
  @override
  void initState() {
    super.initState();
    if(widget.filter != null) {
      widget.model.filter = widget.filter;
    }
    widget.model.getAllStores();
    _scrollController.addListener(_loadMoreItems);
  }

  _loadMoreItems() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        widget.model.hasMoreItems) {
      widget.model.loadMoreStores();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_loadMoreItems);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.transparent,
      appBar: AppBar(title: buildStoreTitle(context),),
      floatingActionButton:FloatingActionButton.extended(
  onPressed: () {
     Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AppointmentForm();
                }));
  },
  icon: Icon(Icons.add),
        backgroundColor: Colors.deepOrange,
  label: Text("Book Appointment"),
),
      body: RefreshIndicator(
        onRefresh: () async {
          await widget.model.refresh();
          return;
        },
        child: ScopedModel<StoreStateModel>(
            model: widget.model,
            child: ScopedModelDescendant<StoreStateModel>(
                builder: (context, child, model) {
              return model.stores != null
                  ? CustomScrollView(
                      controller: _scrollController,
                      slivers: buildListOfBlocks(model.stores, model),
                    )
                  : Center(child: CircularProgressIndicator());
            })),
      ),
    );
  }

  List<Widget> buildListOfBlocks(
      List<StoreModel> stores, StoreStateModel model) {
    List<Widget> list = new List<Widget>();

    if(stores.length > 0) {
      list.add(StoresList(stores: stores));
    }

    list.add(SliverPadding(
        padding: EdgeInsets.all(0.0),
        sliver: SliverList(
            delegate: SliverChildListDelegate([
          model.hasMoreItems
              ? Container(
                  height: 60, child: Center(child: CircularProgressIndicator()))
              : Container()
        ]))));

    return list;
  }

  Row buildStoreTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Container(
            height: 55,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
            child:Text("Appointments",style: TextStyle(fontWeight: FontWeight.normal,fontSize: 20),)
          ),
        ),
      ],
    );
  }
}
