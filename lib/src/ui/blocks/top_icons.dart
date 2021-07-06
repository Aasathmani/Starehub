import 'package:flutter/material.dart';
import '../../../assets/presentation/m_store_icons_icons.dart';
import '../../models/app_state_model.dart';
import '../../ui/accounts/account/account.dart';
import '../../ui/accounts/login/login.dart';
import '../../ui/accounts/wallet.dart';
import '../../ui/accounts/wishlist.dart';
import '../../ui/categories/categories.dart';
import '../../ui/checkout/cart/cart4.dart';

class ShapeIcons extends StatelessWidget {
  const ShapeIcons({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: new Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Account()));
                        },
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                new ClipPath(
                                  clipper: new CustomTopHalfCircleClipper(),
                                  child: new Container(
                                    height: 50.0,
                                    width: 50.0,
                                    decoration: new BoxDecoration(color: Colors.deepOrange.withOpacity(0.8), borderRadius: BorderRadius.circular(25.0) ),
                                  ),
                                ),
                                ClipPath(
                                  clipper: new CustomBottomHalfCircleClipper(),
                                  child: new Container(
                                    height: 50.0,
                                    width: 50.0,
                                    decoration: new BoxDecoration(color: Colors.deepOrange, borderRadius: BorderRadius.circular(25.0) ),
                                  ),
                                ),
                                Container(
                                  width: 50,
                                  height: 50,
                                  child: Icon(
                                    Icons.account_circle,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8,),
                            Text('Account', style: Theme.of(context).textTheme.caption)
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: new Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Categories()));
                        },
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                new ClipPath(
                                  clipper: new CustomTopHalfCircleClipper(),
                                  child: new Container(
                                    height: 50.0,
                                    width: 50.0,
                                    decoration: new BoxDecoration(color: Colors.red.withOpacity(0.8), borderRadius: BorderRadius.circular(25.0) ),
                                  ),
                                ),
                                ClipPath(
                                  clipper: new CustomBottomHalfCircleClipper(),
                                  child: new Container(
                                    height: 50.0,
                                    width: 50.0,
                                    decoration: new BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(25.0) ),
                                  ),
                                ),
                                Container(
                                  width: 50,
                                  height: 50,
                                  child: Icon(
                                    Icons.view_list,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8,),
                            Text('Category', style: Theme.of(context).textTheme.caption)
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: new Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          if (AppStateModel().user?.id != null &&
                              AppStateModel().user.id > 0) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WishList()));
                          } else Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Login()));
                        },
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                new ClipPath(
                                  clipper: new CustomTopHalfCircleClipper(),
                                  child: new Container(
                                    height: 50.0,
                                    width: 50.0,
                                    decoration: new BoxDecoration(color: Colors.deepOrange.withOpacity(0.8), borderRadius: BorderRadius.circular(25.0) ),
                                  ),
                                ),
                                ClipPath(
                                  clipper: new CustomBottomHalfCircleClipper(),
                                  child: new Container(
                                    height: 50.0,
                                    width: 50.0,
                                    decoration: new BoxDecoration(color: Colors.deepOrange, borderRadius: BorderRadius.circular(25.0) ),
                                  ),
                                ),
                                Container(
                                  width: 50,
                                  height: 50,
                                  child: Icon(
                                    Icons.favorite,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8,),
                            Text('Wishlist', style: Theme.of(context).textTheme.caption)
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: new Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CartPage()));
                        },
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                new ClipPath(
                                  clipper: new CustomTopHalfCircleClipper(),
                                  child: new Container(
                                    height: 50.0,
                                    width: 50.0,
                                    decoration: new BoxDecoration(color: Colors.orange.withOpacity(0.8), borderRadius: BorderRadius.circular(25.0) ),
                                  ),
                                ),
                                ClipPath(
                                  clipper: new CustomBottomHalfCircleClipper(),
                                  child: new Container(
                                    height: 50.0,
                                    width: 50.0,
                                    decoration: new BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(25.0) ),
                                  ),
                                ),
                                Container(
                                  width: 50,
                                  height: 50,
                                  child: Icon(
                                    Icons.shopping_basket,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text('Cart', style: Theme.of(context).textTheme.caption)
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: new Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          if (AppStateModel().user?.id != null &&
                              AppStateModel().user.id > 0) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Wallet()));
                          } else Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Login()));
                        },
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                new ClipPath(
                                  clipper: new CustomTopHalfCircleClipper(),
                                  child: new Container(
                                    height: 50.0,
                                    width: 50.0,
                                    decoration: new BoxDecoration(color: Colors.purple.withOpacity(0.8), borderRadius: BorderRadius.circular(25.0) ),
                                  ),
                                ),
                                ClipPath(
                                  clipper: new CustomBottomHalfCircleClipper(),
                                  child: new Container(
                                    height: 50.0,
                                    width: 50.0,
                                    decoration: new BoxDecoration(color: Colors.purple, borderRadius: BorderRadius.circular(25.0) ),
                                  ),
                                ),
                                Container(
                                  width: 50,
                                  height: 50,
                                  child: Icon(
                                    MStoreIcons.wallet_4_line,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text('Wallet', style: Theme.of(context).textTheme.caption)
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTopHalfCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = new Path();
    path.lineTo(0.0, size.height / 2);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width, 0);
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class CustomBottomHalfCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = new Path();
    path.moveTo(0, size.height / 2);
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height /2);
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}