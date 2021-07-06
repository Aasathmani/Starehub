import 'package:app/src/ui/appointments/appointments_form.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'ui/products/product_detail/product_detail.dart';
import 'ui/products/products/products.dart';
import './ui/vendor/ui/stores/stores.dart';
import '../assets/presentation/m_store_icons_icons.dart';
import 'models/app_state_model.dart';
import 'models/category_model.dart';
import 'models/post_model.dart';
import 'models/product_model.dart';
import 'ui/accounts/account/account.dart';
import 'ui/categories/categories.dart';
import 'ui/checkout/cart/cart4.dart';
import 'ui/checkout/order_summary.dart';
import 'ui/home/home.dart';
import 'ui/home/home2.dart';
import 'ui/pages/page_detail.dart';
import 'ui/pages/post_detail.dart';
import 'ui/pages/webview.dart';


class App extends StatefulWidget {
  AppStateModel appStateModel = AppStateModel();
  App({Key key}) : super(key: key);
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with TickerProviderStateMixin {

  //final FirebaseMessaging _firebaseMessaging;
  
  int _currentIndex = 0;
  List<Category> mainCategories;
  List<Widget> _children = [];

  @override
  void initState() {

   // configureFcm();
    initOneSignal();
    if(widget.appStateModel.blocks.settings.home == 'Home2') {
      _children.add(Home2());
    } else {
      _children.add(Home());
    }
    _children.add(Categories());
    //if(widget.appStateModel.blocks.settings.isMultivendor)
    _children.add(AppointmentForm());
    //_children.add(Deals());
    _children.add(CartPage());
    _children.add(Account());
    super.initState();
  }

  void onChangePageIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerDragStartBehavior: DragStartBehavior.start,
     /* floatingActionButton: ScopedModelDescendant<AppStateModel>(
          builder: (context, child, model) {
            if (model.blocks?.settings?.enableHomeChat == 1 && _currentIndex == 0) {
              return FloatingActionButton(
                onPressed: () =>
                    _openWhatsApp(model.blocks.settings.whatsappNumber.toString()),
                tooltip: 'Chat',
                child: Icon(Icons.chat_bubble),
              );
            } else {
              return Container();
            }
          }),*/
      body: _children[_currentIndex],
      bottomNavigationBar: buildBottomNavigationBar(context),
    );
  }


  onProductClick(product) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ProductDetail(product: product);
    }));
  }

  Future _openWhatsApp(String number) async {
    final url = 'https://wa.me/' + number;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  BottomNavigationBar buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: onChangePageIndex,
      backgroundColor: Theme.of(context).appBarTheme.color,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Theme.of(context).primaryColor == Colors.white ? Colors.deepOrange : Colors.deepOrange,
      showSelectedLabels: widget.appStateModel.blocks.settings.showBottomTabLabels,
      showUnselectedLabels: widget.appStateModel.blocks.settings.showBottomTabLabels,
      items: setBottomNavigationBarItem(),
    );
  }

  setBottomNavigationBarItem() {
    List<BottomNavigationBarItem> _bottomNavigationBarItem = [];
    _bottomNavigationBarItem.add(
      BottomNavigationBarItem(
        backgroundColor: Theme.of(context).appBarTheme.color,
        icon: Icon(MStoreIcons.home_line),
        activeIcon: Icon(MStoreIcons.home_fill),
        label: widget.appStateModel.blocks.localeText.home,
      )
    );
    _bottomNavigationBarItem.add(
      BottomNavigationBarItem(
        icon: Icon(MStoreIcons.layout_2_line),
        activeIcon: Icon(MStoreIcons.layout_2_fill),
        label: widget.appStateModel.blocks.localeText.category,
      )
    );
    //if(widget.appStateModel.blocks.settings.isMultivendor)
    _bottomNavigationBarItem.add(
      BottomNavigationBarItem(
          icon: Icon(Icons.assignment_ind_outlined),
          activeIcon: Icon(Icons.assignment_ind),
          label: widget.appStateModel.blocks.localeText.stores
      )
    );
    _bottomNavigationBarItem.add(
        BottomNavigationBarItem(
            icon: Stack(children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: Icon(MStoreIcons.shopping_basket_2_line),
              ),
              new Positioned(
                top: 0.0,
                right: 0.0,
                child: ScopedModelDescendant<AppStateModel>(
                    builder: (context, child, model) {
                      if (model.count != 0) {
                        return Card(
                            elevation: 0,
                            clipBehavior: Clip.antiAlias,
                            shape: StadiumBorder(),
                            color: Colors.red,
                            child: Container(
                                padding: EdgeInsets.all(2),
                                constraints: BoxConstraints(minWidth: 20.0),
                                child: Center(
                                    child: Text(
                                      model.count.toString(),
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                          backgroundColor: Colors.red),
                                    ))));
                      } else
                        return Container();
                    }),
              ),
            ]),
            activeIcon: Stack(children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: Icon(MStoreIcons.shopping_basket_2_fill),
              ),
              new Positioned(
                top: 0.0,
                right: 0.0,
                child: ScopedModelDescendant<AppStateModel>(
                    builder: (context, child, model) {
                      if (model.count != 0) {
                        return Card(
                            elevation: 0,
                            clipBehavior: Clip.antiAlias,
                            shape: StadiumBorder(),
                            color: Colors.red,
                            child: Container(
                                padding: EdgeInsets.all(2),
                                constraints: BoxConstraints(minWidth: 20.0),
                                child: Center(
                                    child: Text(
                                      model.count.toString(),
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                          backgroundColor: Colors.red),
                                    ))));
                      } else
                        return Container();
                    }),
              ),
            ]),
            label: widget.appStateModel.blocks.localeText.cart
        )
    );
    _bottomNavigationBarItem.add(
        BottomNavigationBarItem(
            icon: Icon(MStoreIcons.account_circle_line),
            activeIcon: Icon(MStoreIcons.account_circle_fill),
            label: widget.appStateModel.blocks.localeText.account
        )
    );
    return _bottomNavigationBarItem;
  }

  Future<void> initOneSignal() async {

    /*OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);

    if(model.blocks.settings.onesignalAppId.isNotEmpty) {

      var settings = {
        OSiOSSettings.autoPrompt: false,
        OSiOSSettings.promptBeforeOpeningPushUrl: true
      };

      await OneSignal.shared.init(
          model.blocks.settings.onesignalAppId, //add your OneSignal app Id
          iOSSettings: {
            OSiOSSettings.autoPrompt: false,
            OSiOSSettings.inAppLaunchUrl: false
          }
      );

      OneSignal.shared.setRequiresUserPrivacyConsent(true);

      OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {

        print("Opened notification: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}");

      });

      var status = await OneSignal.shared.getPermissionSubscriptionState();

      model.oneSignalPlayerId = status.subscriptionStatus.userId;

      model.apiProvider.post('/wp-admin/admin-ajax.php?action=mstore_flutter_update_user_notification', {'onesignal_user_id': model.oneSignalPlayerId});
    }*/
  }

  /*Future<void> configureFcm() async {
     await Future.delayed(Duration(seconds: 10));

     NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(announcement: true, criticalAlert: true,);

     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {_onMessage(message);});


     FirebaseMessaging.instance.getToken().then((String token) {
       assert(token != null);
       widget.appStateModel.fcmToken = token;
       widget.appStateModel.apiProvider.post('/wp-admin/admin-ajax.php?action=mstore_flutter_update_user_notification', {'fcm_token': token});
     });
  }*/

  void _onMessage(message) {
    if (message != null && message.isNotEmpty) {
      if (message['category'] != null) {
        var filter = new Map<String, dynamic>();
        filter['id'] = message['category'];
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ProductsWidget(filter: filter, name: '')));
      } else if (message['product'] != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetail(
                  product: Product(
                    id: message['product'],
                    name: '',
                  ),
                )));
      } else if (message['page'] != null) {
        var post = Post();
        post.id = int.parse(message['page']);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => PageDetail(post: post)));
      } else if (message['post'] != null) {
        var post = Post();
        post.id = int.parse(message['post']);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => PostDetail(post: post)));
      } else if (message['link'] != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    WebViewPage(url: message['link'], title: '')));
      } else if (message['order'] != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    OrderSummary(id: message['order'])));
      }
    }
  }
}