import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../../ui/products/products/product_grid.dart';
import '../../../layout/text_scale.dart';
import '../product_grid/product_item.dart';
import '../product_detail/product_detail.dart';
import '../../../models/app_state_model.dart';
import '../../../models/product_model.dart';
import '../../accounts/login/login.dart';
import 'products.dart';

class ProductScroll extends StatelessWidget {
  const ProductScroll({
    Key key,
    @required this.products,
    @required this.context,
    @required this.title,
    this.viewAllTitle,
    this.filter,
  }) : super(key: key);

  final List<Product> products;
  final BuildContext context;
  final String title;
  final String viewAllTitle;
  final Map<String, dynamic> filter;

  @override
  Widget build(BuildContext context) {
    if (products.length > 0) {
      return Container(
        child: SliverList(
          delegate: SliverChildListDelegate(
            [
              products.length != null
                  ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          margin: EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
                          child: Text(title,
                              style: Theme.of(context).textTheme.headline6)),
                      viewAllTitle != null ? Container(
                          margin: EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProductsWidget(
                                          filter: filter,
                                          name: title)));
                            },
                            child: Text(viewAllTitle,
                                style: Theme.of(context).textTheme.bodyText2),
                          )) : Container(),
                    ],
                  )
                  : Container(),
              Container(
                constraints: new BoxConstraints(
                  minHeight: 240.0,
                  maxHeight: AppStateModel().blocks.settings.listingAddToCart ? 440.0 : 390,
                ),
                child: ListView.builder(
                    padding: EdgeInsets.all(12.0),
                    scrollDirection: Axis.horizontal,
                    itemCount: products.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          width: 210,
                          child: ProductItemCard(
                              product: products[index]));
                    }),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        child: SliverToBoxAdapter(),
      );
    }
  }
}