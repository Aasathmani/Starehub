import 'package:app/src/ui/appointments/appointments_form.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../../models/app_state_model.dart';
import '../../../../models/vendor/store_model.dart';
import '../../../../models/vendor/store_state_model.dart';
import 'search_store.dart';
import 'store_list/store_list.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show Encoding, json;
import 'package:shared_preferences/shared_preferences.dart';


class Stores extends StatefulWidget {
  final Map<String, dynamic> filter;
  final StoreStateModel model = StoreStateModel();

  Stores({Key key, this.filter}) : super(key: key);
  @override
  _StoresState createState() => _StoresState();
}

class _StoresState extends State<Stores> {
  List service=[];
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
      appBar: AppBar(title: buildStoreTitle(context),),
          floatingActionButton:FloatingActionButton.extended(
  onPressed:  (){
    FetchServices();


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

  final url="https://starehub.com/android_api/FetchServices.php";
  void FetchServices() async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    var serviceslist;



    try{
    final response=await post(Uri.parse(url),body:{
      "key":"621c64f8fdaa244a217b2e8984cdeea36f311412",

  }, headers: {"Content-Type": "application/x-www-form-urlencoded"},

        encoding: Encoding.getByName("gzip"),
    );
    print(response.body);
    var reBody = json.decode(response.body)['messages'];
    prefs.setStringList("serviceslist",reBody);

  }catch(er){}
}




List<Widget> buildListOfBlocks(
      List<StoreModel> stores, StoreStateModel model) {
    List<Widget> list = new List<Widget>();
    list.add(StoresList(stores: stores));
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
            child:Text("Appointments",style: TextStyle(fontWeight: FontWeight.normal,fontSize: 20),)/* InkWell(
              borderRadius: BorderRadius.circular(25),
              enableFeedback: false,
              splashColor: Colors.transparent,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SearchStores();
                }));
              },
              child: TextField(
                showCursor: false,
                enabled: false,
                decoration: InputDecoration(
                  hintText: appStateModel.blocks.localeText.searchStores,
                  hintStyle: TextStyle(
                    fontSize: 16,

                  ),
                  fillColor: Theme.of(context).primaryColor == Colors.white ? Theme.of(context).inputDecorationTheme.fillColor : Theme.of(context).brightness == Brightness.dark ? Theme.of(context).inputDecorationTheme.fillColor : Colors.white,
                  filled: true,
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(
                      color: Theme.of(context).focusColor,
                      width: 0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(
                      color: Theme.of(context).focusColor,
                      width: 0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(
                      color: Theme.of(context).focusColor,
                      width: 0,
                    ),
                  ),
                  contentPadding: EdgeInsets.all(6),
                  prefixIcon: Icon(
                    FontAwesomeIcons.search,
                    size: 18,
                  ),
                ),
              ),
            ),*/
          ),
        ),
      ],
    );
  }
}
